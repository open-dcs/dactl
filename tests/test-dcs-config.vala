/**
 * Dummy class to instantiate an abstract class for testing.
 */
public class Dcs.Test.Config : Dcs.Config {

    construct {
        format = Dcs.ConfigFormat.XML;
    }
}

public class Dcs.Test.CmdlineConfig : Dcs.Config {

    private static bool test_a = false;
    private static bool test_b = false;

    private static Dcs.Test.CmdlineConfig config;

    const OptionEntry[] options = {
        { "test-a", 'a', 0, OptionArg.NONE, ref test_a, "Test A", null },
        { "test-b", 'b', 0, OptionArg.NONE, ref test_b, "Test B", null },
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

    public bool get_test_a () throws GLib.Error {
        if (test_a == false) {
            throw new Dcs.ConfigError.NO_VALUE_SET ("No value available");
        }

        return test_a;
    }

    public bool get_test_b () throws GLib.Error {
        if (test_b == false) {
            throw new Dcs.ConfigError.NO_VALUE_SET ("No value available");
        }

        return test_b;
    }
}

public abstract class Dcs.ConfigTestsBase : Dcs.TestCase {

    protected Dcs.Config test_config;

    public ConfigTestsBase (string name) {
        base (name);
    }
}

public class Dcs.ConfigTests : Dcs.ConfigTestsBase {

    private const string class_name = "DcsConfig";

    public ConfigTests () {
        base (class_name);
        add_test (@"[$class_name] Test format property", test_format);
        add_test (@"[$class_name] Test command line args", test_load_cmdline);
        add_test (@"[$class_name] Test loading INI file", test_load_ini);
        add_test (@"[$class_name] Test loading INI data", test_load_ini_data);
        add_test (@"[$class_name] Test loading JSON file", test_load_json);
        add_test (@"[$class_name] Test loading JSON data", test_load_json_data);
        add_test (@"[$class_name] Test loading XML file", test_load_xml);
        add_test (@"[$class_name] Test loading XML data", test_load_xml_data);
    }

    public override void set_up () {
        test_config = new Dcs.Test.Config ();
    }

    public override void tear_down () {
        test_config = null;
    }

    private void test_format () {
        /* XXX Should this be tested by eg. a config.load ("file.ini"); ??? */
        test_config.format = Dcs.ConfigFormat.OPTIONS;
        assert_true (test_config.format == Dcs.ConfigFormat.OPTIONS);
        test_config.format = Dcs.ConfigFormat.INI;
        assert_true (test_config.format == Dcs.ConfigFormat.INI);
        test_config.format = Dcs.ConfigFormat.JSON;
        assert_true (test_config.format == Dcs.ConfigFormat.JSON);
        test_config.format = Dcs.ConfigFormat.XML;
        assert_true (test_config.format == Dcs.ConfigFormat.XML);
    }

    private void test_load_cmdline () {
        string[] args = {
            "--test-a",
            "--test-b"
        };
        unowned string[] test_args = args;
        /* This is the only test where the common class isn't relevant */
        Dcs.Test.CmdlineConfig.parse_args (ref test_args);
        var _test_config = Dcs.Test.CmdlineConfig.get_default ();
        try {
            assert_true ((_test_config as Dcs.Test.CmdlineConfig).get_test_a ());
            assert_true ((_test_config as Dcs.Test.CmdlineConfig).get_test_b ());
        } catch (GLib.Error e) {
        }
    }

    private void test_load_ini () {
        assert_true (true);
    }

    private void test_load_ini_data () {
        assert_true (true);
    }

    private void test_load_json () {
        assert_true (true);
    }

    private void test_load_json_data () {
        assert_true (true);
    }

    private void test_load_xml () {
        assert_true (true);
        /*
         *test_config.config_loaded.connect ((res) => {
         *    assert_true (res);
         *});
         *test_config.load ("data/test-config.xml");
         *assert_true (test_config.format == Dcs.ConfigFormat.XML);
         */
    }

    private void test_load_xml_data () {
        assert_true (true);
        /*
         *string xml = """
         *  <?xml version="1.0" encoding="ISO-8859-1"?>
         *  <dcs xmlns:daq="urn:libdcs-daq" xmlns:net="urn:libdcs-net">
         *    <!--
         *      - This doesn't need to contain anything yet, but it should have
         *      - more to validate for instance number of objects constructed or
         *      - depth possibly.
         *      -->
         *  </dcs>
         *""";
         *test_config.config_loaded.connect ((res) => {
         *    assert_true (res);
         *});
         *test_config.load_data (xml, Dcs.ConfigFormat.XML);
         *assert_true (test_config.format == Dcs.ConfigFormat.XML);
         */
    }
}
