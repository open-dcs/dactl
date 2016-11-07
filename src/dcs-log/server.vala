public class Dcs.Recorder.Server : Dcs.CLI.Application {

    private static Once<Dcs.Recorder.Server> _instance;

    private GLib.MainLoop loop;

    private Dcs.Recorder.RestService rest_service;

    public Dcs.Recorder.ZmqClient zmq_client;

    public static unowned Dcs.Recorder.Server get_default () {
        return _instance.once (() => {
            return new Dcs.Recorder.Server ();
        });
    }

    internal Server () {
        GLib.Object (application_id: "org.opendcs.dcs.log");

        loop = new GLib.MainLoop ();

        rest_service = new Dcs.Recorder.RestService.with_port (8089);
        zmq_client = new Dcs.Recorder.ZmqClient.with_conn_info (
            Dcs.Net.ZmqTransport.TCP, "127.0.0.1", 5588);
    }

    protected override void activate () {
        base.activate ();

        debug (_("Activating Recorder Server"));
    }

    protected override void startup () {
        base.startup ();

        debug (_("Starting Recorder server > ZMQ Client"));
        zmq_client.run ();

        debug (_("Starting Recorder server > Main"));
        loop.run ();
    }

    protected override void shutdown () {
        debug (_("Shuting down Recorder Server"));
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
