public class Dcs.Net.Publisher : Dcs.Node {

    private ZMQ.Context context;

    private ZMQ.Socket socket;

    /**
     * Port number to use with the service.
     */
    public int port { get; set; default = 5000; }

    public string transport_spec {
        get {
            string spec = transport.to_string ();
            unowned string _spec = spec;
            return _spec;
        }
        set { transport = Dcs.Net.ZmqTransport.parse (value); }
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
    public string address { get; set; default = "*"; }

	/**
	 * Signals that new data was published to the socket.
     */
    public signal void data_published (uint8[] data);

    public Publisher () {
        try {
            init ();
        } catch (Dcs.Net.ZmqError e) {
            critical (e.message);
        }
    }

    public Publisher.with_conn_info (Dcs.Net.ZmqTransport transport,
                                     string address,
                                     int port) {
        GLib.Object (transport: transport,
                     address: address,
                     port: port);
        try {
            init ();
        } catch (Dcs.Net.ZmqError e) {
            critical (e.message);
        }
    }

    protected void init () throws Dcs.Net.ZmqError {
        string endpoint = null;

        context = new ZMQ.Context ();
        socket = ZMQ.Socket.create (context, ZMQ.SocketType.PUB);

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

        debug ("Publish to %s", endpoint);

        var ret = socket.bind (endpoint);

        if (ret == -1) {
            throw new Dcs.Net.ZmqError.INIT (
                _("An error ocurred while binding to endpoint"));
        }
    }
}
