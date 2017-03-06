/**
 * Mock object of command line option based configurations for testing.
 */
public class Dcs.Test.CmdlineConfig : Dcs.AbstractConfig {

    private static bool _test_a = false;
    private static bool _test_b = false;
    private static bool _test_c = false;
    private static string? _test_string = "";
    private static int _test_int = 0;
    private static double _test_double = 0;

    /* Things need to be properties for get_'property-type' methods to work */

    public bool   test_a      { get { return _test_a; } }
    public bool   test_b      { get { return _test_b; } }
    public bool   test_c      { get { return _test_c; } }
    public string test_string { get { return _test_string; } }
    public int    test_int    { get { return _test_int; } }
    public double test_double { get { return _test_double; } }

    private static Dcs.Test.CmdlineConfig config;

    const OptionEntry[] options = {
        { "test-a", 'a', 0, OptionArg.NONE, ref _test_a, "Test A", null },
        { "test-b", 'b', 0, OptionArg.NONE, ref _test_b, "Test B", null },
        { "test-c", 'c', 0, OptionArg.NONE, ref _test_c, "Test C", null },
        { "test-string", 0, 0, OptionArg.STRING, ref _test_string, "Test String", null },
        { "test-int",    0, 0, OptionArg.INT, ref _test_int, "Test Integer", null },
        { "test-double", 0, 0, OptionArg.DOUBLE, ref _test_double, "Test Double", null },
        { null }
    };

    public static Dcs.Test.CmdlineConfig get_default () {
        if (config == null) {
            config = new Dcs.Test.CmdlineConfig ();
        }
        return config;
    }

    public static void parse_args (ref unowned string[] args)
                                   throws GLib.OptionError {
        var opt_context = new OptionContext ("Test Suite - libdcs-core");
        opt_context.set_help_enabled (false);
        opt_context.set_ignore_unknown_options (true);
        opt_context.add_main_entries (options, null);

        try {
            opt_context.parse (ref args);
        } catch (GLib.OptionError.BAD_VALUE e) {
            /* XXX Don't care? */
        }
    }

    public override void dump (GLib.FileStream stream) {
        var str = "";
        str += "Test A:\t\t%s\n".printf ((test_a) ? "true" : "false");
        str += "Test B:\t\t%s\n".printf ((test_b) ? "true" : "false");
        str += "Test C:\t\t%s\n".printf ((test_c) ? "true" : "false");
        str += "Test str:\t%s\n".printf (test_string);
        str += "Test int:\t%d\n".printf (test_int);
        str += "Test dbl:\t%f\n".printf (test_double);
        stream.write (str.data);
    }

    public void set_format (Dcs.ConfigFormat fmt) {
        if (fmt.is_valid ()) {
            format = fmt;
        }
    }

    public override Dcs.ConfigFormat get_format () throws GLib.Error {
        return format;
    }

    public override string get_string (string ns,
                                       string key) throws GLib.Error {
        try {
            unowned string val;
            Dcs.Config.check_property_type (typeof (Dcs.Test.CmdlineConfig),
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
            Dcs.Config.check_property_type (typeof (Dcs.Test.CmdlineConfig),
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
            Dcs.Config.check_property_type (typeof (Dcs.Test.CmdlineConfig),
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
            Dcs.Config.check_property_type (typeof (Dcs.Test.CmdlineConfig),
                                            typeof (double),
                                            key);
            @get (key, out val);
            return val;
        } catch (GLib.Error e) {
            throw e;
        }
    }
}
