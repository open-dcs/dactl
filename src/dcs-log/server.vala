public class Dcs.Recorder.Server : Dcs.Net.Service {

    private GLib.MainLoop loop;

    /* Application specific configuration */
    private Dcs.Config service_config;

    /* Command line options read into configuration */
    private Dcs.Config cmdline_config;

    private Dcs.Net.Factory net_factory;

    /* TODO Lower the REST handler to the service class */
    private Dcs.Recorder.RestService rest_service;

    internal Server () {
        GLib.Object (application_id: "org.opendcs.dcs.log",
                     flags: ApplicationFlags.HANDLES_COMMAND_LINE);

        debug (_("Constructing Recorder server"));
        loop = new GLib.MainLoop ();

        service_config = new Dcs.Recorder.Config ();
        cmdline_config = Dcs.Recorder.CmdlineConfig.get_default ();

        net_factory = Dcs.Net.Factory.get_default ();

        /* Perform the base initialization */
        init ();

        /* Register the known configuration pieces */
        Dcs.MetaConfig.register_config (cmdline_config);

        /* Register the known factories that are needed */
        Dcs.FooMetaFactory.register_factory (net_factory);

        /* XXX these should go after the config gets loaded */
        rest_service = new Dcs.Recorder.RestService (this);

        /* Create the plugin manager that loads the backend plugins */
        plugin_manager = new Dcs.Log.BackendManager (this);
        plugin_manager.load_plugin_configurations ();
        //plugin_manager.register_plugin_configurations ();
        //plugin_manager.register_plugin_factories ();
    }

    protected override void activate () {
        debug (_("Activating Recorder server"));
        base.activate ();

        string? filename = null;

        /* Attempt to find a configuration file */
        try {
            filename = config.get_string ("dcs", "config");
        } catch (GLib.Error e) {
            if (e is Dcs.ConfigError.NO_VALUE_SET) {
                string[] filenames = {
                    GLib.Path.build_filename (GLib.Environment.get_home_dir (),
                                              ".config", "dcs", "dcs-log.xml"),
                    GLib.Path.build_filename (GLib.Environment.get_home_dir (),
                                              ".config", "dcs", "dcs-log.json"),
                    GLib.Path.build_filename (Dcs.Build.DATADIR, "dcs-log.xml"),
                    GLib.Path.build_filename (Dcs.Build.DATADIR, "dcs-log.json"),
                };
                /* Take the first configuration that was found */
                foreach (var file in filenames) {
                    if (FileUtils.test (file, FileTest.EXISTS)) {
                        filename = file;
                        break;
                    } else {
                        debug ("File %s does not exist, trying next", file);
                    }
                }
                debug ("Configuration file not provided at prompt, using %s", filename);
            } else {
                critical (e.message);
            }
        }

        /* Should have a configuration at this point to load and register */
        if (filename != null) {
            (service_config as Dcs.Recorder.Config).load_file (filename);
            //(service_config as Dcs.Recorder.Config).dump (stdout);
            Dcs.MetaConfig.register_config (service_config);
        } else {
            critical ("No configuration available or provided");
        }

        try {
            /* Use any configuration that's available at this point to build */
            construct_model ();

            //(plugin_manager as Dcs.Log.BackendManager).enable_backend ("xml");
            (plugin_manager as Dcs.Log.BackendManager).start_backends ();
        } catch (GLib.Error e) {
            critical (e.message);
        }

        /* Construction of plugins shouldn't cause the service to fail */
        try {
            /* Start as a service including starting configured sockets */
            this.start ();
        } catch (GLib.Error e) {
            critical (e.message);
        }

        loop.run ();
    }

    protected override void startup () {
        debug (_("Starting Recorder server"));
        base.startup ();
    }

    protected override void shutdown () {
        debug (_("Shuting down Recorder Server"));
        loop.quit ();

        base.shutdown ();
    }

    public virtual int launch (string[] args) {
        return (this as GLib.Application).run (args);
    }

    private int _command_line (GLib.ApplicationCommandLine cmdline) {
        try {
            string[] args1 = cmdline.get_arguments ();
            unowned string[] args2 = args1;
            this.hold ();
            Dcs.Recorder.CmdlineConfig.parse_args (ref args2);
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
