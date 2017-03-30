public class Dcs.DAQ.CmdlineConfig : Dcs.AbstractConfig {

    private static string _config = "";

    public string config { get { return _config; } }

    const OptionEntry[] options = {
        { "config", 'c', 0, OptionArg.NONE, ref _config, "Configuration File", null },
        { null }
    };

    /* Singleton for this configuration */
    private static Once<Dcs.DAQ.CmdlineConfig> _instance;

    public static unowned Dcs.DAQ.CmdlineConfig get_default () {
        return _instance.once (() => { return new Dcs.DAQ.CmdlineConfig (); });
    }

    public static void parse_args (ref unowned string[] args)
                                   throws GLib.OptionError {
        var opt_context = new OptionContext ("DCS Data Acquisition Service");
        opt_context.set_help_enabled (false);
        opt_context.set_ignore_unknown_options (true);
        opt_context.add_main_entries (options, null);

        try {
            opt_context.parse (ref args);
        } catch (GLib.OptionError.BAD_VALUE e) {
            critical (e.message);
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
            Dcs.Config.check_property_type (typeof (Dcs.DAQ.CmdlineConfig),
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
            Dcs.Config.check_property_type (typeof (Dcs.DAQ.CmdlineConfig),
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
            Dcs.Config.check_property_type (typeof (Dcs.DAQ.CmdlineConfig),
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
            Dcs.Config.check_property_type (typeof (Dcs.DAQ.CmdlineConfig),
                                            typeof (double),
                                            key);
            @get (key, out val);
            return val;
        } catch (GLib.Error e) {
            throw e;
        }
    }
}
