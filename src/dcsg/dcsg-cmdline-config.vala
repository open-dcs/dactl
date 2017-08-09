public errordomain Dcsg.CmdlineConfigError {
    VERSION_ONLY
}

public class Dcsg.CmdlineConfig : Dcs.AbstractConfig {

    private static bool version;

    private static string plugin_path;

    private static string config_file;

    private static bool replace;

    /* Singleton */
    private static Dcsg.CmdlineConfig config;

    const OptionEntry[] options = {
        { "version", 0, 0, OptionArg.NONE, ref version,
          "Display version number", null },
        { "plugin-path", 'u', 0, OptionArg.STRING, ref plugin_path,
          N"Plugin Path", "PLUGIN_PATH" },
        { "config", 'c', 0, OptionArg.FILENAME, ref config_file,
          N"Use configuration file instead of user configuration", "FILE" },
        { "replace", 'r', 0, OptionArg.NONE, ref replace,
          N"Replace currently running instance of dcsg", null },
        { null }
    };

    public static CmdlineConfig get_default () {
        if (config == null) {
            config = new Dcsg.CmdlineConfig ();
        }
        return config;
    }

    public static void parse_args (ref unowned string[] args)
                                   throws CmdlineConfigError.VERSION_ONLY,
                                          OptionError {
        var parameter_string = "- " + Dcs.Build.PACKAGE_NAME;
        var opt_context = new OptionContext (parameter_string);
        opt_context.set_help_enabled (true);
        opt_context.set_ignore_unknown_options (true);
        opt_context.add_main_entries (options, null);

        try {
            opt_context.parse (ref args);
        } catch (OptionError.BAD_VALUE err) {
            stdout.printf (opt_context.get_help (true, null));

            throw new Dcsg.CmdlineConfigError.VERSION_ONLY ("");
        }

        if (version) {
            stdout.printf ("%s\n", Dcs.Build.PACKAGE_STRING);

            throw new Dcsg.CmdlineConfigError.VERSION_ONLY ("");
        }
    }

    public string get_plugin_path () throws GLib.Error {
        if (plugin_path == null) {
            throw new Dcs.ConfigError.NO_VALUE_SET ("No value available");
        }

        return plugin_path;
    }

    public string get_config_file () throws GLib.Error {
        if (config_file == null) {
            throw new Dcs.ConfigError.NO_VALUE_SET ("No value available");
        }

        return config_file;
    }

    public override Dcs.ConfigFormat get_format () throws GLib.Error {
        return Dcs.ConfigFormat.OPTIONS;
    }

    public override string get_namespace () throws GLib.Error {
        return "dcsg";
    }
}
