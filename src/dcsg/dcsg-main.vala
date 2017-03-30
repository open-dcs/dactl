internal class Dcsg.Main : GLib.Object {

    private struct Options {

        public static bool cli = false;
        public static  bool version = false;

        public static const GLib.OptionEntry[] entries = {{
            "cli", 'c', 0, OptionArg.NONE, ref cli,
            "Start the application with a command line interface", null
        },{
            "verbose", 'v', OptionFlags.NO_ARG, OptionArg.CALLBACK, (void *) verbose_cb,
            "Provide verbose debugging output.", null
        },{
            "version", 'V', 0, OptionArg.NONE, ref version,
            "Display version number.", null
        },{
            null
        }};
    }

    private bool verbose_cb () {
        Dcs.SysLog.increase_verbosity ();
        return true;
    }

    private static void parse_local_args (ref unowned string[] args) {
        var opt_context = new OptionContext (Dcs.Build.PACKAGE_NAME);
        opt_context.set_ignore_unknown_options (true);
        opt_context.set_help_enabled (false);
        opt_context.add_main_entries (Options.entries, null);

        try {
            opt_context.parse (ref args);
        } catch (OptionError e) {
        }

        if (Options.version) {
            stdout.printf ("%s - version %s\n", args[0], Dcs.Build.PACKAGE_VERSION);
            Posix.exit (0);
        }
    }

    private static int PLUGIN_TIMEOUT = 5;

    private Dcs.Application app;
    private Dcs.MetaFactory factory;
    private Dcs.PluginLoader plugin_loader;
    private Dcs.SysLog log;

    /* XXX testing Peas plugin manager */
    private Dcs.UI.PluginManager plugin_manager;

    private int exit_code;

    public bool need_restart;

    private Main () throws GLib.Error {
        log = Dcs.SysLog.get_default ();
        log.init (true, null);

        factory = Dcs.MetaFactory.get_default ();
        plugin_loader = new Dcs.PluginLoader ();

        exit_code = 0;

        app = Dcsg.Application.get_default ();

        /* TODO transition to new Peas plugin manager */
        (app as Dcsg.Application).view_constructed.connect (() => {
            plugin_manager = new Dcs.UI.PluginManager (app);
        });

        plugin_loader.plugin_available.connect (on_plugin_loaded);

        Unix.signal_add (Posix.SIGHUP,  () => { restart (); return true; });
        Unix.signal_add (Posix.SIGINT,  () => { exit (0);   return true; });
        Unix.signal_add (Posix.SIGTERM, () => { exit (0);   return true; });
    }

    /**
     * XXX should implement a state dump to capture errors and configuration
     *     when this happens
     */
    public void exit (int exit_code) {
        this.exit_code = exit_code;
        Dcs.SysLog.shutdown ();
        (app as Dcsg.Application).shutdown ();
    }

    public void restart () {
        need_restart = true;
        exit (0);
    }

    private int run (string[] args) {
        debug (_("OpenDCS GUI v%s starting..."), Dcs.Build.PACKAGE_VERSION);
        app.launch (args);

        return exit_code;
    }

    internal void dbus_available () {
        plugin_loader.load_modules ();

        var timeout = PLUGIN_TIMEOUT;
        //try {
            /*
             *var config = MetaConfig.get_default ();
             *timeout = config.get_int ("plugin",
             *                          "TIMEOUT",
             *                          PLUGIN_TIMEOUT,
             *                          int.MAX);
             */
        //} catch (GLib.Error e) {};

        Timeout.add_seconds (timeout, () => {
            if (plugin_loader.list_plugins ().size == 0) {
                warning (ngettext ("No plugins found in %d second; giving up...",
                                   "No plugins found in %d seconds; giving up...",
                                   PLUGIN_TIMEOUT),
                                   PLUGIN_TIMEOUT);

                // FIXME: this causes the application to close the device connections
                //this.exit (-82);
            } else {
                debug ("Plugin timeout is complete, assuming all are loaded");
            }

            return false;
        });
    }

    private void on_plugin_loaded (Dcs.PluginLoader plugin_loader,
                                   Dcs.LegacyPlugin plugin) {
        if (plugin.has_factory) {
            Dcs.MetaFactory.register_factory (plugin.factory);
        }

        app.plugins.add (plugin);
        app.register_plugin (plugin);
        if (app.plugins.size > 0) {
            debug ("Added `%s', there are now %d plugins loaded",
                     plugin.name, app.plugins.size);
        }

        /*
         *var iterator = this.factories.iterator ();
         *while (iterator.next ()) {
         *    this.create_device.begin (plugin, iterator.get ());
         *}
         */
    }

    private static void register_default_factories () {
        var ui_factory = Dcs.UI.Factory.get_default ();
        Dcs.MetaFactory.register_factory (ui_factory);
    }

    private static int main (string[] args) {

        Dcsg.Main main = null;
        Dcsg.DBusService service = null;

        var original_args = args;

        Intl.setlocale (LocaleCategory.ALL, "");
        Intl.bindtextdomain (Dcs.Build.GETTEXT_PACKAGE, Dcs.Build.LOCALEDIR);
        Intl.bind_textdomain_codeset (Dcs.Build.GETTEXT_PACKAGE, "UTF-8");
        Intl.textdomain (Dcs.Build.GETTEXT_PACKAGE);

        GLib.Environment.set_prgname (_(Dcs.Build.PACKAGE_NAME));
        GLib.Environment.set_application_name (_(Dcs.Build.PACKAGE_NAME));

        try {
            parse_local_args (ref args);

            Dcsg.Main.register_default_factories ();

            main = new Dcsg.Main ();
            service = new Dcsg.DBusService (main);
            service.publish ();
        } catch (GLib.Error e) {
            error ("%s", e.message);
        }

        /* Launch the application */
        int exit_code = main.run (args);

        if (service != null) {
            service.unpublish ();
        }

        if (main.need_restart) {
            Posix.execvp (original_args[0], original_args);
        }

        return exit_code;
    }
}
