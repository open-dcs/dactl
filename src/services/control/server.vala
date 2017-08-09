public class Dcs.Control.Server : Dcs.Net.Service {

    private GLib.MainLoop loop;

    /* Application specific configuration */
    private Dcs.Config service_config;

    /* Command line options read into configuration */
    private Dcs.Config cmdline_config;

    private Dcs.Net.Factory net_factory;

    private Dcs.Control.Factory control_factory;

    private Dcs.Net.Replier reply_channel;

    /* TODO Lower the REST handler to the service class */
    public Dcs.Control.Router router;

    internal Server () {
        GLib.Object (application_id: "org.opendcs.dcs.control",
                     flags: ApplicationFlags.HANDLES_COMMAND_LINE);

        debug ("Constructing Control server");
        loop = new GLib.MainLoop ();

        service_config = new Dcs.Control.Config ();
        cmdline_config = Dcs.Control.CmdlineConfig.get_default ();

        net_factory = Dcs.Net.Factory.get_default ();
        control_factory = Dcs.Control.Factory.get_default ();

        /* Performs the base initialization */
        init ();

        /* Register the known configuration pieces */
        Dcs.MetaConfig.register_config (cmdline_config);

        /* Register the known factories that are needed */
        Dcs.FooMetaFactory.register_factory (net_factory);
        Dcs.FooMetaFactory.register_factory (control_factory);

        /* XXX these should go after the config gets loaded */
        router = new Dcs.Control.Router (this);

        /* Create the plugin manager which loads loop plugins */
        plugin_manager = new Dcs.Control.LoopManager (this);
        plugin_manager.load_plugin_configurations ();
        //plugin_manager.register_plugin_configurations ();
        //plugin_manager.register_plugin_factories ();
    }

    protected override void activate () {
        debug ("Activating Control server");
        base.activate ();

        string? filename = null;

        /* Attempt to find a configuration file */
        try {
            filename = config.get_string ("dcs", "config");
        } catch (GLib.Error e) {
            if (e is Dcs.ConfigError.NO_VALUE_SET) {
                string[] filenames = {
                    GLib.Path.build_filename (GLib.Environment.get_home_dir (),
                                              ".config", "dcs", "dcs-control.xml"),
                    GLib.Path.build_filename (GLib.Environment.get_home_dir (),
                                              ".config", "dcs", "dcs-control.json"),
                    GLib.Path.build_filename (Dcs.Build.DATADIR, "dcs-control.xml"),
                    GLib.Path.build_filename (Dcs.Build.DATADIR, "dcs-control.json"),
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
            (service_config as Dcs.Control.Config).load_file (filename);
            //(service_config as Dcs.Control.Config).dump (stdout);
            Dcs.MetaConfig.register_config (service_config);
        } else {
            critical ("No configuration available or provided");
        }

        try {
            /* Use any configuration that's available at this point to build */
            construct_model ();
            var nodes = get_model ().get_descendants (typeof (Dcs.Node));
            debug ("Configured %d nodes", nodes.size);
            /*
             *foreach (var node in nodes) {
             *    debug (node.to_string ());
             *}
             */
            debug ("Model tree:\n%s", Dcs.Node.tree (get_model ()));

            var net = get_model ().@get ("net");
            var rc = config.get_string ("dcs", "reply-channel");
            debug ("Replying channel: %s", rc);
            if (net.has_key (rc)) {
                reply_channel = (Dcs.Net.Replier) net.@get (rc);
            }

            //(plugin_manager as Dcs.Control.LoopManager).enable_loop ("pid");
            (plugin_manager as Dcs.Control.LoopManager).start_loops ();
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

    public override void construct_model () throws GLib.Error {
        debug ("Constructing the Control service data model");
        if (initialized) {
            model = new Dcs.FooModel();
            var net = new Dcs.Node ();
            net.id = "net";
            var control = new Dcs.Node ();
            control.id = "control";
            foreach (var config_node in config.get_children ()) {
                var node = factory.produce_from_config (config_node);
                var type = node.get_type ();
                if (type.name ().has_prefix ("DcsControl")) {
                    control.add (node);
                } else if (type.name ().has_prefix ("DcsNet")) {
                    net.add (node);
                }
            }
            model.add (control);
            model.add (net);
        } else {
            throw new Dcs.ApplicationError.NOT_INITIALIZED (
                "The application was not initialized correctly");
        }
    }

    protected override void startup () {
        debug ("Starting Control server");
        base.startup ();
    }

    protected override void shutdown () {
        debug ("Shuting down Control Server");
        loop.quit ();

        base.shutdown ();
    }

    private int _command_line (GLib.ApplicationCommandLine cmdline) {
        try {
            string[] args1 = cmdline.get_arguments ();
            unowned string[] args2 = args1;
            this.hold ();
            Dcs.Control.CmdlineConfig.parse_args (ref args2);
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
