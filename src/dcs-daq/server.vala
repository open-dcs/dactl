public class Dcs.DAQ.Server : Dcs.FooApplication {

    private GLib.MainLoop loop;

    /* Application specific configuration */
    private Dcs.Config service_config;

    /* Command line options read into configuration */
    private Dcs.Config cmdline_config;

    private Dcs.Net.Factory net_factory;

    /* XXX These should be nested in a node set */
    public Dcs.DAQ.RestService rest_service;

    public Dcs.DAQ.ZmqService zmq_service;

    /* Application construction */
    internal Server () {
        GLib.Object (application_id: "org.opendcs.dcs.daq",
                     flags: ApplicationFlags.HANDLES_COMMAND_LINE);

        debug (_("Constructing DAQ server"));
        loop = new GLib.MainLoop ();

        service_config = new Dcs.DAQ.Config ();
        cmdline_config = Dcs.DAQ.CmdlineConfig.get_default ();

        net_factory = Dcs.Net.Factory.get_default ();

        /* Performs the base initialization */
        init ();

        /* Register the known configuration pieces */
        Dcs.MetaConfig.register_config (cmdline_config);

        /* Register the known factories that are needed */
        Dcs.FooMetaFactory.register_factory (net_factory);

        // XXX these should go after the config gets loaded
        rest_service = new Dcs.DAQ.RestService ();
        zmq_service = new Dcs.DAQ.ZmqService.with_conn_info (
            Dcs.Net.ZmqTransport.TCP, "*", 5588);
    }

    protected override void activate () {
        base.activate ();

        /* The config should be loaded, build node tree */
        try {
            var filename = config.get_string ("dcs", "config");
            (service_config as Dcs.DAQ.Config).load_file (filename);
            (service_config as Dcs.DAQ.Config).dump (stdout);
            Dcs.MetaConfig.register_config (service_config);
            var node = factory.produce_from_config_list (config.get_children ());
            stdout.printf (@"$node");
        } catch (GLib.Error e) {
            critical (e.message);
        }

        debug (_("Activating DAQ server"));
        loop.run ();
    }

    protected override void startup () {
        debug (_("Starting DAQ server > Main"));
        base.startup ();

        debug (_("Starting DAQ server > ZMQ Service"));
        zmq_service.run ();
    }

    protected override void shutdown () {
        debug (_("Shuting down DAQ Server"));
        loop.quit ();

        base.shutdown ();
    }

    private int _command_line (GLib.ApplicationCommandLine cmdline) {
        try {
            string[] args1 = cmdline.get_arguments ();
            unowned string[] args2 = args1;
            this.hold ();
            Dcs.DAQ.CmdlineConfig.parse_args (ref args2);
            this.release ();
        } catch (OptionError e) {
            cmdline.printerr ("error: %s\n", e.message);
            return 1;
        }

        return 0;
    }

    public override int command_line (ApplicationCommandLine cmdline) {
        this.hold ();
        int res = _command_line (cmdline);
        activate ();
        this.release ();

        return res;
    }
}
