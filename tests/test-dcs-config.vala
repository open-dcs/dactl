public abstract class Dcs.ConfigTestsBase : Dcs.TestCase {

    protected Dcs.Config config;

    protected Dcs.Test.CmdlineConfig cmdline_config;

    protected Dcs.Config meta_config;

    public ConfigTestsBase (string name) {
        base (name);
    }
}

public class Dcs.ConfigTests : Dcs.ConfigTestsBase {

    private const string class_name = "DcsConfig";

    public ConfigTests () {
        base (class_name);
        add_test (@"[$class_name] Test format property", test_format);
        add_test (@"[$class_name] Test namespace property", test_namespace);
        add_test (@"[$class_name] Test command line args", test_load_cmdline);
        add_test (@"[$class_name] Test meta configuration", test_meta_config);
        add_test (@"[$class_name] Test loading INI file", test_load_ini);
        add_test (@"[$class_name] Test loading INI data", test_load_ini_data);
        add_test (@"[$class_name] Test loading JSON file", test_load_json);
        add_test (@"[$class_name] Test loading JSON data", test_load_json_data);
        add_test (@"[$class_name] Test loading XML file", test_load_xml);
        add_test (@"[$class_name] Test loading XML data", test_load_xml_data);
    }

    public override void set_up () {
        config = new Dcs.Test.Config ();
        cmdline_config = Dcs.Test.CmdlineConfig.get_default ();
        meta_config = Dcs.MetaConfig.get_default ();
    }

    public override void tear_down () {
        config = null;
    }

    private void test_format () {
        /* XXX Should this be tested by eg. a config.load ("file.ini"); ??? */
        (config as Dcs.Test.Config).set_format (Dcs.ConfigFormat.OPTIONS);
        assert (config.get_format () == Dcs.ConfigFormat.OPTIONS);
        (config as Dcs.Test.Config).set_format (Dcs.ConfigFormat.INI);
        assert (config.get_format () == Dcs.ConfigFormat.INI);
        (config as Dcs.Test.Config).set_format (Dcs.ConfigFormat.JSON);
        assert (config.get_format () == Dcs.ConfigFormat.JSON);
        (config as Dcs.Test.Config).set_format (Dcs.ConfigFormat.XML);
        assert (config.get_format () == Dcs.ConfigFormat.XML);
        (config as Dcs.Test.Config).set_format (Dcs.ConfigFormat.INVALID);
        assert (config.get_format ().is_valid () == true);
    }

    private void test_namespace () {
        (config as Dcs.Test.Config).set_namespace ("dcs");
        assert (config.get_namespace () == "dcs");
    }

    private void test_load_cmdline () {
        string[] args = {
            "test-dcs-core",
            "--test-a",
            "--test-b",
            "--test-string", "string",
            "--test-int", "1",
            "--test-double", "1.0"
        };
        unowned string[] test_args = args;
        Dcs.Test.CmdlineConfig.parse_args (ref test_args);
        try {
            assert ((cmdline_config as Dcs.Test.CmdlineConfig).get_format () == Dcs.ConfigFormat.OPTIONS);
            assert (cmdline_config.test_a == true);
            assert (cmdline_config.test_b == true);
            assert (cmdline_config.test_c == false);
            assert (cmdline_config.get_bool ("dcs", "test-a") == true);
            assert (cmdline_config.get_bool ("dcs", "test-b") == true);
            assert (cmdline_config.get_bool ("dcs", "test-c") == false);
            assert (cmdline_config.get_string ("dcs", "test-string") == "string");
            assert (cmdline_config.get_int ("dcs", "test-int") == 1);
            assert (cmdline_config.get_double ("dcs", "test-double") == 1.0);
        } catch (GLib.Error e) {
            debug (e.message);
            if (e is Dcs.ConfigError) {
                assert (false);
            }
        }
    }

    private void test_meta_config () {
        assert (meta_config.get_namespace () == "dcs");
        /* Load a default config to use */
        var filename = Path.build_filename (Dcs.Test.Build.CONFIG_DIR, "test-config.xml");
        (config as Dcs.Test.Config).load_file (filename, Dcs.ConfigFormat.XML);
        config.dump (stdout);
        Dcs.MetaConfig.register_config (config);
        Dcs.MetaConfig.register_config (cmdline_config);
        try {
            assert (meta_config.get_format () == Dcs.ConfigFormat.MIXED);
            /* Test a cmdline config property */
            assert (meta_config.get_bool ("dcs", "test-a") == true);
            /* Test a base config property */
            assert (meta_config.get_string ("dcs", "sprop") == "string");
        } catch (GLib.Error e) {
            debug (e.message);
            if (e is Dcs.ConfigError) {
                assert (false);
            }
        }
    }

    private void test_property_getters () throws GLib.Error {
        try {
            assert (config.get_string ("dcs", "sprop") == "string");
            var slist = config.get_string_list ("dcs", "slprop");
            assert_nonnull (slist);
            foreach (var item in slist) {
                assert (item == "string");
            }
            assert (config.get_int ("dcs", "iprop") == 1);
            var ilist = config.get_int_list ("dcs", "ilprop");
            assert_nonnull (ilist);
            foreach (var item in ilist) {
                assert (item == 1);
            }
            assert (config.get_bool ("dcs", "bprop") == true);
            assert (config.get_double ("dcs", "dprop") == 1.0);
        } catch (GLib.Error e) {
            throw e;
        }
    }

    private void test_property_setters () throws GLib.Error {
        try {
            config.set_string ("dcs", "sprop", "test");
            assert (config.get_string ("dcs", "sprop") == "test");
            config.set_int ("dcs", "iprop", 2);
            assert (config.get_int ("dcs", "iprop") == 2);
            config.set_bool ("dcs", "bprop", false);
            assert (config.get_bool ("dcs", "bprop") == false);
            config.set_double ("dcs", "dprop", 2.0);
            assert (config.get_double ("dcs", "dprop") == 2.0);
        } catch (GLib.Error e) {
            throw e;
        }
    }

    private void test_load_ini () {
        try {
            var filename = Path.build_filename (Dcs.Test.Build.CONFIG_DIR, "test-config.ini");
            (config as Dcs.Test.Config).load_file (filename, Dcs.ConfigFormat.INI);
            assert (config.get_format () == Dcs.ConfigFormat.INI);
            test_property_getters ();
            test_property_setters ();
            //config.dump (stdout);
        } catch (GLib.Error e) {
            debug (e.message);
            if (e is Dcs.ConfigError) {
                assert (false);
            }
        }
    }

    private void test_load_ini_data () {
        string ini = """
          [dcs]
          sprop = string
          slprop = string,string
          iprop = 1
          ilprop = 1,1
          bprop = true
          dprop = 1.0
        """;

        try {
            (config as Dcs.Test.Config).load_data (ini, Dcs.ConfigFormat.INI);
            assert (config.get_format () == Dcs.ConfigFormat.INI);
            test_property_getters ();
            test_property_setters ();
            //config.dump (stdout);
        } catch (GLib.Error e) {
            debug (e.message);
            if (e is Dcs.ConfigError) {
                assert (false);
            }
        }
    }

    private void test_load_json () {
        try {
            var filename = Path.build_filename (Dcs.Test.Build.CONFIG_DIR, "test-config.json");
            (config as Dcs.Test.Config).load_file (filename, Dcs.ConfigFormat.JSON);
            assert (config.get_format () == Dcs.ConfigFormat.JSON);
            test_property_getters ();
            test_property_setters ();
            //config.dump (stdout);
        } catch (GLib.Error e) {
            debug (e.message);
            if (e is Dcs.ConfigError) {
                assert (false);
            }
        }
    }

    private void test_load_json_data () {
        string json = """
          {
            "dcs": {
              "properties": {
                "sprop": "string",
                "slprop": ["string","string"],
                "iprop": 1,
                "ilprop": [1,1],
                "bprop": true,
                "dprop": 1.0
              }
            }
          }
        """;

        try {
            (config as Dcs.Test.Config).load_data (json, Dcs.ConfigFormat.JSON);
            assert (config.get_format () == Dcs.ConfigFormat.JSON);
            test_property_getters ();
            test_property_setters ();
            //config.dump (stdout);
        } catch (GLib.Error e) {
            debug (e.message);
            if (e is Dcs.ConfigError) {
                assert (false);
            }
        }
    }

    private void test_load_xml () {
        try {
            var filename = Path.build_filename (Dcs.Test.Build.CONFIG_DIR, "test-config.xml");
            (config as Dcs.Test.Config).load_file (filename, Dcs.ConfigFormat.XML);
            assert (config.get_format () == Dcs.ConfigFormat.XML);
            test_property_getters ();
            test_property_setters ();
            //config.dump (stdout);
        } catch (GLib.Error e) {
            debug (e.message);
            if (e is Dcs.ConfigError) {
                assert (false);
            }
        }
    }

    private void test_load_xml_data () {
        string xml = """
          <dcs xmlns:daq="urn:libdcs-daq" xmlns:net="urn:libdcs-net">
            <!--
              - This doesn't need to contain anything yet, but it should have
              - more to validate for instance number of objects constructed or
              - depth possibly.
              -->
            <property name="sprop">string</property>
            <property name="slprop">string,string</property>
            <property name="iprop">1</property>
            <property name="ilprop">1,1</property>
            <property name="bprop">true</property>
            <property name="dprop">1.0</property>
          </dcs>
        """;

        try {
            (config as Dcs.Test.Config).load_data (xml, Dcs.ConfigFormat.XML);
            assert (config.get_format () == Dcs.ConfigFormat.XML);
            test_property_getters ();
            test_property_setters ();
            //config.dump (stdout);
        } catch (GLib.Error e) {
            debug (e.message);
            if (e is Dcs.ConfigError) {
                assert (false);
            }
        }
    }
}
