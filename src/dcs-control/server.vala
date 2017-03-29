public class Dcs.Control.Server : Dcs.CLI.Application {

    private GLib.MainLoop loop;

    private Dcs.Control.RestService rest_service;

    public Dcs.Control.ZmqService zmq_service;

    public Dcs.Control.ZmqClient zmq_client;

    internal Server () {
        GLib.Object (application_id: "org.opendcs.dcs.control");

        loop = new GLib.MainLoop ();

        rest_service = new Dcs.Control.RestService.with_port (8090);
        zmq_client = new Dcs.Control.ZmqClient.with_conn_info (
            Dcs.Net.ZmqTransport.TCP, "127.0.0.1", 5588);
        zmq_service = new Dcs.Control.ZmqService.with_conn_info (
            Dcs.Net.ZmqTransport.TCP, "*", 5589);
    }

    protected override void activate () {
        base.activate ();

        debug (_("Activating Control Server"));
        loop.run ();
    }

    protected override void startup () {
        debug (_("Starting Control server > Main"));
        base.startup ();

        debug (_("Starting Control server > ZMQ Client"));
        zmq_client.run ();

        debug (_("Starting Control server > ZMQ Service"));
        zmq_service.run ();
    }

    protected override void shutdown () {
        debug (_("Shuting down Control Server"));
        loop.quit ();

        base.shutdown ();
    }

    public virtual int launch (string[] args) {
        return (this as GLib.Application).run (args);
    }

    static bool opt_help;
    static const OptionEntry[] options = {{
        "help", 'h', 0, OptionArg.NONE, ref opt_help, null, null
    },{
        null
    }};

    public override int command_line (GLib.ApplicationCommandLine cmdline) {
        opt_help = false;

        var opt_context = new OptionContext (Dcs.Build.PACKAGE_NAME);
        opt_context.add_main_entries (options, null);
        opt_context.set_help_enabled (false);

        try {
            string[] args1 = cmdline.get_arguments ();
            unowned string[] args2 = args1;
            opt_context.parse (ref args2);
        } catch (OptionError e) {
            cmdline.printerr ("error: %s\n", e.message);
            cmdline.printerr (opt_context.get_help (true, null));
            return 1;
        }

        if (opt_help) {
            cmdline.printerr (opt_context.get_help (true, null));
        }

        return 0;
    }
}
