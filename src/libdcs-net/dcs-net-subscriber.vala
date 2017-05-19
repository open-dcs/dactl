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

        /*
         *filter = "\"data\":";
         */
        debug (_("Setting ZMQ subscription filter to: %s"), filter);
        socket.setsockopt (ZMQ.SocketOption.SUBSCRIBE,
                           filter,
                           filter.length);
    }

    public bool is_connected () {
        return connected;
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
}
