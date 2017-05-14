public class Dcs.Net.Subscriber : Dcs.Node {

    private ZMQ.Context context;

    private ZMQ.Socket socket;

    private bool connected = false;

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
            debug (_("Setting ZMQ subscription filter to: %s"), value);
            socket.setsockopt (ZMQ.SocketOption.SUBSCRIBE,
                               filter,
                               filter.length);
        }
    }

	/**
	 * Signals that new data was received on the socket.
     */
    public signal void data_received (uint8[] data);

    public Subscriber () { }

    public Subscriber.with_conn_info (Dcs.Net.ZmqTransport transport,
                                      string address,
                                      int port) {
        GLib.Object (transport: transport,
                     address: address,
                     port: port);
    }

    public void start () throws Dcs.Net.ZmqError {
        try {
            init ();
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

        connected = true;

        filter = "\"data\":";
    }

    public bool is_connected () {
        return connected;
    }
}

