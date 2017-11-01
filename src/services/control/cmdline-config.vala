public class Dcs.Control.CmdlineConfig : Dcs.AbstractConfig {

    private static string? _config = null;
    private static bool _verbose = false;
    private static bool _version = false;

    public string config { get { return _config; } }

    const OptionEntry[] options = {
        { "config", 'c', 0, OptionArg.FILENAME, ref _config, "Configuration File", null },
        { "verbose", 'v', 0, OptionArg.NONE, ref _verbose, "Provide verbose output", null },
        { "version", 'V', 0, OptionArg.NONE, ref _version, "Display version number", null },
        { null }
    };

    /* Singleton for this configuration */
    private static Once<Dcs.Control.CmdlineConfig> _instance;

    public static unowned Dcs.Control.CmdlineConfig get_default () {
        return _instance.once (() => { return new Dcs.Control.CmdlineConfig (); });
    }

    public static void parse_args (ref unowned string[] args)
                                   throws GLib.OptionError {
        var opt_context = new OptionContext ("DCS Feedback Control Service");
        opt_context.set_help_enabled (true);
        opt_context.set_ignore_unknown_options (true);
        opt_context.add_main_entries (options, null);

        try {
            opt_context.parse (ref args);
        } catch (GLib.OptionError.BAD_VALUE e) {
            critical (e.message);
            stdout.printf (opt_context.get_help (true, null));
        }

        if (_version) {
            stdout.printf ("%s - version %s\n", args[0], Dcs.VERSION);
            Posix.exit (0);
        }
    }

    public override Dcs.ConfigFormat get_format () throws GLib.Error {
        format = Dcs.ConfigFormat.OPTIONS;
        return format;
    }

    public override string get_string (string ns,
                                       string key) throws GLib.Error {
        try {
            unowned string val;
            Dcs.Config.check_property_type (typeof (Dcs.Control.CmdlineConfig),
                                            typeof (string),
                                            key);
            @get (key, out val);
            return val;
        } catch (GLib.Error e) {
            throw e;
        }
    }

    public override int get_int (string ns,
                                 string key) throws GLib.Error {
        try {
            int val;
            Dcs.Config.check_property_type (typeof (Dcs.Control.CmdlineConfig),
                                            typeof (int),
                                            key);
            @get (key, out val);
            return val;
        } catch (GLib.Error e) {
            throw e;
        }
    }

    public override bool get_bool (string ns,
                                   string key) throws GLib.Error {
        try {
            bool val;
            Dcs.Config.check_property_type (typeof (Dcs.Control.CmdlineConfig),
                                            typeof (bool),
                                            key);
            @get (key, out val);
            return val;
        } catch (GLib.Error e) {
            throw e;
        }
    }

    public override double get_double (string ns,
                                       string key) throws GLib.Error {
        try {
            double val;
            Dcs.Config.check_property_type (typeof (Dcs.Control.CmdlineConfig),
                                            typeof (double),
                                            key);
            @get (key, out val);
            return val;
        } catch (GLib.Error e) {
            throw e;
        }
    }
}
