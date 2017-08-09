public errordomain Dcs.Net.ZmqError {
    INIT,
    RUN_FAILURE;
}

public abstract class Dcs.Net.ZmqService : GLib.Object {

    protected ZMQ.Context context;

    protected ZMQ.Socket publisher;

    /**
     * Port number to use with the service.
     */
    public int port { get; construct set; default = 5000; }

    /**
     * Transport to use with the service.
     */
    public Dcs.Net.ZmqTransport transport {
        get;
        construct set;
        default = Dcs.Net.ZmqTransport.INPROC;
    }

    /**
     * Address to use with the service.
     */
    public string address { get; construct set; default = "*"; }

    public signal void data_published (uint8[] data);

    public ZmqService () {
        try {
            init ();
        } catch (Dcs.Net.ZmqError e) {
            critical (e.message);
        }
    }

    public ZmqService.with_conn_info (Dcs.Net.ZmqTransport transport,
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
        publisher = ZMQ.Socket.create (context, ZMQ.SocketType.PUB);

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

        debug ("Connect to %s", endpoint);

        var ret = publisher.bind (endpoint);

        if (ret == -1) {
            throw new Dcs.Net.ZmqError.INIT (
                "An error ocurred while binding to endpoint");
        }
    }

    public abstract void run ();

    protected abstract async void listen () throws ThreadError;

    public string to_string () {
        return "ZmqService: %s://%s:%d".printf (transport.to_string (),
                                                address,
                                                port);
    }
}
