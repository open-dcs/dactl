public class Dcs.Net.Subscriber : Dcs.Node {

    private ZMQ.Context context;

    private ZMQ.Socket socket;

    private bool running = false;

    private string? _filter = null;

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

    /**
     * An optional filter to use to limit what's being received.
     */
    public string? filter {
        get { return _filter; }
        set {
            _filter = value;
            debug (_("Setting subscriber filter to: %s"), value);
            socket.setsockopt (ZMQ.SocketOption.SUBSCRIBE,
                               filter,
                               filter.length);
        }
    }

	/**
	 * Signals that new data was received on the socket.
     */
    public signal void data_received (uint8[] data);

    public Subscriber.with_conn_info (Dcs.Net.ZmqTransport transport,
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
            } else {
                throw new Dcs.RunnableError.ALREADY_RUNNING (
                    "Socket provider %s is already running", id);
            }
        } catch (Dcs.Net.ZmqError e) {
            throw e;
        }
    }

    protected void init () throws Dcs.Net.ZmqError {
        string endpoint = null;

        context = new ZMQ.Context ();
        socket = ZMQ.Socket.create (context, ZMQ.SocketType.SUB);

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

        debug ("Subscribe to %s", endpoint);

        var ret = socket.connect (endpoint);

        if (ret == -1) {
            throw new Dcs.Net.ZmqError.INIT (
                _("An error ocurred while binding to endpoint"));
        }

        running = true;

        /*
         *filter = "\"data\":";
         */
        debug (_("Setting ZMQ subscription filter to: %s"), filter);
        socket.setsockopt (ZMQ.SocketOption.SUBSCRIBE,
                           filter,
                           filter.length);
    }

    public bool is_running () {
        return running;
    }

    /**
     * XXX Should consider putting the threading here and pass the data back
     * using a signal. Reduces the effort required by the socket user.
     * XXX Could also pass the data back through a stream.
     */
    public Dcs.Message recv_message () {
        var msg = ZMQ.Msg ();
        var n = msg.recv (socket);
        size_t size = msg.size () + 1;
        uint8[] data = new uint8[size];
        //Dcs.Message message = new Dcs.Message ();
        Dcs.Message message = new Dcs.Message.alert ("alert0");

        GLib.Memory.copy (data, msg.data, size - 1);
        data[size - 1] = '\0';
        debug ((string) data);
        //var json = Json.from_string ((string) data);
        //debug (Json.to_string (json, false));
        //message.deserialize (Json.to_string (json, false));

        return message;
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
        builder.add_string_value ("subscriber");
        builder.set_member_name ("properties");
        builder.begin_object ();
        builder.set_member_name ("port");
        builder.add_int_value (port);
        builder.set_member_name ("address");
        builder.add_string_value (address);
        builder.set_member_name ("transport-spec");
        builder.add_string_value (transport.to_string ());
        builder.set_member_name ("filter");
        builder.add_string_value (filter);
        builder.end_object ();
        builder.end_object ();
        builder.end_object ();

        var node = builder.get_root ();
        if (node == null) {
            throw new Dcs.SerializationError.SERIALIZE_FAILURE (
                "Failed to serialize subscriber %s", id);
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
            filter = props.get_string_member ("filter");
        }
    }
}
