public class Dcs.Net.Requester : Dcs.Node {

    private ZMQ.Context context;

    private ZMQ.Socket socket;

    private bool connected = false;

    private bool running = false;

    private Gee.Queue<Dcs.Message> message_queue;

    /**
     * Port number to use with the service.
     */
    public int port { get; set; default = 5000; }

    private string _transport_spec = "inproc";
    /**
     * Transport to use with the service as a configurable string.
     */
    public string transport_spec {
        get {
            /*
             *string spec = transport.to_string ();
             *unowned string _spec = spec;
             *return _spec;
             */
            return _transport_spec;
        }
        set {
            _transport_spec = value;
            transport = Dcs.Net.ZmqTransport.parse (value);
        }
    }

    /**
     * Transport to use with the service.
     */
    public Dcs.Net.ZmqTransport transport {
        get;
        set;
        default = Dcs.Net.ZmqTransport.INPROC;
    }

    /**
     * Address to use with the service.
     */
    public string address { get; set; default = "127.0.0.1"; }

    construct {
        message_queue = new Gee.ArrayQueue<Dcs.Message> ();
    }

    public Requester.with_conn_info (Dcs.Net.ZmqTransport transport,
                                     string address,
                                     int port) {
        GLib.Object (transport: transport,
                     address: address,
                     port: port);
    }

    public void start () throws GLib.Error {
        try {
            if (!running) {
                init ();
                running = true;
                relay.begin ((obj, res) => {
                    try {
                        relay.end (res);
                    } catch (ThreadError e) {
                        throw new Dcs.Net.ZmqError.RUN_FAILURE (e.message);
                    }
                });
            } else {
                throw new Dcs.RunnableError.ALREADY_RUNNING (
                    "Socket provider %s is already running", id);
            }
        } catch (Dcs.Net.ZmqError e) {
            throw e;
        }
    }

    /* TODO check status of thread and throw error if fail to stop */
    public void stop () throws Dcs.Net.ZmqError {
        running = false;
    }

    protected void init () throws Dcs.Net.ZmqError {
        string endpoint = null;

        context = new ZMQ.Context ();
        socket = ZMQ.Socket.create (context, ZMQ.SocketType.REQ);

        switch (transport) {
            case ZmqTransport.INPROC:
                endpoint = "%s://%s".printf (transport.to_string (), address);
                break;
            case ZmqTransport.IPC:
            case ZmqTransport.TCP:
            case ZmqTransport.PGM:
                endpoint = "%s://%s:%d".printf (transport.to_string (),
                                                address,
                                                port);
                break;
            default:
                assert_not_reached ();
        }

        debug ("Make requests to %s", endpoint);

        var ret = socket.connect (endpoint);

        if (ret == -1) {
            throw new Dcs.Net.ZmqError.INIT (
                _("An error ocurred while binding to endpoint"));
        }

        connected = true;
    }

    public bool is_connected () {
        return connected;
    }

    public void send_message (Dcs.Message msg) {
        /* Add a message to the internal queue */
        lock (message_queue) {
            message_queue.offer (msg);
        }
    }

    private async void relay () throws ThreadError {
        SourceFunc callback = relay.callback;

        ThreadFunc<void*> run = () => {
            while (running) {
                /* XXX need to wait for messages on the queue somewhere else and
                 * use the delegate to send here */
                /* XXX watch the internal queue and pop all available? */
                Posix.sleep (600);
                debug ("I should be making requests here");
                /*
                 *lock (message_queue) {
                 *    var msg = message_queue.poll ();
                 *}
                 */
            }

            Idle.add ((owned) callback);
            return null;
        };

        Thread.create<void*> (run, false);
        yield;
    }

    /**
     * {@inheritDoc}
     */
    public virtual Json.Node json_serialize () throws GLib.Error {
        var builder = new Json.Builder ();
        builder.begin_object ();
        builder.set_member_name (id);
        builder.begin_object ();
        builder.set_member_name ("type");
        builder.add_string_value ("requester");
        builder.set_member_name ("properties");
        builder.begin_object ();
        builder.set_member_name ("port");
        builder.add_int_value (port);
        builder.set_member_name ("address");
        builder.add_string_value (address);
        builder.set_member_name ("transport-spec");
        builder.add_string_value (transport.to_string ());
        builder.end_object ();
        builder.end_object ();
        builder.end_object ();

        var node = builder.get_root ();
        if (node == null) {
            throw new Dcs.SerializationError.SERIALIZE_FAILURE (
                "Failed to serialize requester %s", id);
        }

        return node;
    }

    /**
     * {@inheritDoc}
     */
    public virtual void json_deserialize (Json.Node node) throws GLib.Error {
        var obj = node.get_object ();
        id = obj.get_members ().nth_data (0);
        var data = obj.get_object_member (id);

        if (data.has_member ("properties")) {
            var props = data.get_object_member ("properties");
            port = (int) props.get_int_member ("port");
            address = props.get_string_member ("address");
            transport_spec = props.get_string_member ("transport-spec");
        }
    }
}
