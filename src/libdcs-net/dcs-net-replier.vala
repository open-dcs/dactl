namespace Dcs.Net {

    public delegate Dcs.Message ResponseFunc (Dcs.Message message);
}

public class Dcs.Net.Replier : Dcs.Node {

    private ZMQ.Context context;

    private ZMQ.Socket socket;

    private bool running = false;

    private Dcs.Net.ResponseFunc response_func;

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
    public string address { get; set; default = "*"; }

	/**
	 * Signals that new data was published to the socket.
     */
    public signal void data_published (uint8[] data);

    public Replier.with_conn_info (Dcs.Net.ZmqTransport transport,
                                   string address,
                                   int port) {
        GLib.Object (transport: transport,
                     address: address,
                     port: port);
    }

    public void start (Dcs.Net.ResponseFunc func) throws Dcs.Net.ZmqError {
        response_func = func;
        try {
            init ();
            running = true;
            listen.begin ((obj, res) => {
                try {
                    listen.end (res);
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
        socket = ZMQ.Socket.create (context, ZMQ.SocketType.REP);

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

        debug ("Reply on %s", endpoint);

        var ret = socket.bind (endpoint);

        if (ret == -1) {
            throw new Dcs.Net.ZmqError.INIT (
                _("An error ocurred while binding to endpoint"));
        }
    }

    private async void listen () throws ThreadError {
        SourceFunc callback = listen.callback;

        ThreadFunc<void*> run = () => {
            while (running) {
                /* XXX nead to resolve the difference in the vapi I'm using for zeromq */
                //[> Read a request <]
                //var request = ZMQ.Msg ();
                //socket.recv (ref request);
                //[> Generate a reponse using the provided method <]
                //var msg = response_func (request.data ());
                //[> Reply <]
                //var reply = Msg.with_data (msg.serialize ().data);
                //socket.send (reply);
                Posix.sleep (1);
                debug ("I should be responding to a request");
            }

            Idle.add ((owned) callback);
            return null;
        };

        Thread.create<void*> (run, false);
        yield;
    }
}
