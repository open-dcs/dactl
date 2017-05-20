public class Dcs.Net.Requester : Dcs.Node {

    private ZMQ.Context context;

    private ZMQ.Socket socket;

    private bool connected = false;

    private bool running = false;

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

    public Requester.with_conn_info (Dcs.Net.ZmqTransport transport,
                                     string address,
                                     int port) {
        GLib.Object (transport: transport,
                     address: address,
                     port: port);
    }

    public void start () throws Dcs.Net.ZmqError {
        try {
            init ();
            running = true;
            relay.begin ((obj, res) => {
                try {
                    relay.end (res);
                } catch (ThreadError e) {
                    throw new Dcs.Net.ZmqError.RUN_FAILURE (e.message);
                }
            });
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
        /*
         *lock (queue) {
         *    queue.push (msg);
         *}
         */
    }

    private async void relay () throws ThreadError {
        SourceFunc callback = relay.callback;

        ThreadFunc<void*> run = () => {
            while (running) {
                /* XXX need to wait for messages on the queue somewhere else and
                 * use the delegate to send here */
                /* XXX watch the internal queue and pop all available? */
                Posix.sleep (10);
                debug ("I should be making requests here");
            }

            Idle.add ((owned) callback);
            return null;
        };

        Thread.create<void*> (run, false);
        yield;
    }
}
