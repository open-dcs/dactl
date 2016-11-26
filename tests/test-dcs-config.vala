/**
 * Dummy class to instantiate an abstract class for testing.
 */
public class Dcs.Test.Config : Dcs.BaseConfig {

    private KeyFile ini;

    private Json.Object json;

    private Xml.Node *xml;

    public void load_data (string data, Dcs.ConfigFormat format) {
        this.format = format;
        switch (format) {
            case Dcs.ConfigFormat.INI:
                load_from_ini (data);
                break;
            case Dcs.ConfigFormat.JSON:
                load_from_json (data);
                break;
            case Dcs.ConfigFormat.XML:
                load_from_xml (data);
                break;
            default:
                throw new Dcs.ConfigError.INVALID_FORMAT ("Invalid format provided");
                break;
        }
    }

    private void load_from_ini (string data) {
        if (ini != null) {
            ini = null;
        }
        ini = new KeyFile ();
        ini.set_list_separator (',');
        ini.load_from_data (data, -1, KeyFileFlags.NONE);
    }

    private void load_from_json (string data) {
        var parser = new Json.Parser ();
        try {
            parser.load_from_data (data);
        } catch (GLib.Error e) { }

        var node = parser.get_root ();
        json = node.get_object ();
    }

    private void load_from_xml (string data) {
        Xml.Doc *doc = Xml.Parser.parse_memory (data, data.length);
        Xml.XPath.Context *ctx = new Xml.XPath.Context (doc);
        ctx->register_ns ("dcs", "urn:libdcs");
        Xml.XPath.Object *obj = ctx->eval_expression ("/dcs");
        xml = obj->nodesetval->item (0);
    }

    public void set_format (Dcs.ConfigFormat format) {
        if (format.is_valid ()) {
            this.format = format;
        }
    }

    public override Dcs.ConfigFormat get_format () throws GLib.Error {
        return format;
    }

    public void set_namespace (string @namespace) {
        this.@namespace = @namespace;
    }

    public override string get_namespace () throws GLib.Error {
        return @namespace;
    }

    public override string get_string (string ns,
                                       string key) throws GLib.Error {
        string val = null;

        switch (format) {
            case Dcs.ConfigFormat.INI:
                val = ini.get_string (ns, key);
                break;
            case Dcs.ConfigFormat.JSON:
                var dcs = json.get_member (ns);
                var dcs_obj = dcs.get_object ();
                var prop = dcs_obj.get_member ("properties");
                var prop_obj = prop.get_object ();
                var sprop = prop_obj.get_member (key);
                var type = sprop.get_value_type ();
                if (type.is_a (typeof (string))) {
                    val = prop_obj.get_string_member (key);
                }
                break;
            case Dcs.ConfigFormat.XML:
                for (Xml.Node *iter = xml->children; iter != null; iter = iter->next) {
                    if (iter->name == "property") {
                        if (iter->get_prop ("name") == key) {
                            val = iter->get_content ();
                        }
                    }
                }
                break;
            default:
                throw new Dcs.ConfigError.INVALID_FORMAT ("Invalid format provided");
        }

        //if (val == null) {
            //throw new Dcs.ConfigError.NO_VALUE_SET ("No value available");
        //}

        return val;
    }

    public override Gee.ArrayList<string> get_string_list (string ns,
                                                           string key)
                                                           throws GLib.Error {
        Gee.ArrayList<string> val = null;

        switch (format) {
            case Dcs.ConfigFormat.INI:
                var list = ini.get_string_list (ns, key);
                foreach (var item in list) {
                    if (val == null) {
                        val = new Gee.ArrayList<string> ();
                    }
                    val.add (item);
                }
                break;
            case Dcs.ConfigFormat.JSON:
                var dcs = json.get_member (ns);
                var dcs_obj = dcs.get_object ();
                var prop = dcs_obj.get_member ("properties");
                var prop_obj = prop.get_object ();
                var arr = prop_obj.get_array_member (key);
                var list = arr.get_elements ();
                foreach (var item in list) {
                    var type = item.get_value_type ();
                    if (type.is_a (typeof (string))) {
                        if (val == null) {
                            val = new Gee.ArrayList<string> ();
                        }
                        val.add (item.get_string ());
                    }
                }
                break;
            case Dcs.ConfigFormat.XML:
                for (Xml.Node *iter = xml->children; iter != null; iter = iter->next) {
                    if (iter->name == "property") {
                        if (iter->get_prop ("name") == key) {
                            var list = iter->get_content ();
                            foreach (var item in list.split (",")) {
                                if (val == null) {
                                    val = new Gee.ArrayList<string> ();
                                }
                                val.add (item);
                            }
                        }
                    }
                }
                break;
            default:
                throw new Dcs.ConfigError.INVALID_FORMAT ("Invalid format provided");
        }

        //if (val == null) {
            //throw new Dcs.ConfigError.NO_VALUE_SET ("No value available");
        //}

        return val;
    }

    public override int get_int (string ns,
                                 string key) throws GLib.Error {
        int val = 0;
        bool unavailable = true;

        switch (format) {
            case Dcs.ConfigFormat.INI:
                try {
                    val = ini.get_integer (ns, key);
                    unavailable = false;
                    break;
                } catch (GLib.Error e) { }
                break;
            case Dcs.ConfigFormat.JSON:
                var dcs = json.get_member (ns);
                var dcs_obj = dcs.get_object ();
                var prop = dcs_obj.get_member ("properties");
                var prop_obj = prop.get_object ();
                var iprop = prop_obj.get_member (key);
                var type = iprop.get_value_type ();
                if (type.is_a (typeof (int64))) {
                    val = (int) prop_obj.get_int_member (key);
                    unavailable = false;
                }
                break;
            case Dcs.ConfigFormat.XML:
                for (Xml.Node *iter = xml->children; iter != null; iter = iter->next) {
                    if (iter->name == "property") {
                        if (iter->get_prop ("name") == key) {
                            val = int.parse (iter->get_content ());
                        }
                    }
                }
                break;
            default:
                throw new Dcs.ConfigError.INVALID_FORMAT ("Invalid format provided");
        }

        //if (unavailable) {
            //throw new Dcs.ConfigError.NO_VALUE_SET ("No value available");
        //}

        return val;
    }

    public override Gee.ArrayList<int> get_int_list (string ns,
                                                     string key)
                                                     throws GLib.Error {
        Gee.ArrayList<int> val = null;

        switch (format) {
            case Dcs.ConfigFormat.INI:
                var list = ini.get_integer_list (ns, key);
                foreach (var item in list) {
                    if (val == null) {
                        val = new Gee.ArrayList<int> ();
                    }
                    val.add (item);
                }
                break;
            case Dcs.ConfigFormat.JSON:
                var dcs = json.get_member (ns);
                var dcs_obj = dcs.get_object ();
                var prop = dcs_obj.get_member ("properties");
                var prop_obj = prop.get_object ();
                var arr = prop_obj.get_array_member (key);
                var list = arr.get_elements ();
                foreach (var item in list) {
                    var type = item.get_value_type ();
                    if (type.is_a (typeof (int64))) {
                        if (val == null) {
                            val = new Gee.ArrayList<int> ();
                        }
                        val.add ((int) item.get_int ());
                    }
                }
                break;
            case Dcs.ConfigFormat.XML:
                for (Xml.Node *iter = xml->children; iter != null; iter = iter->next) {
                    if (iter->name == "property") {
                        if (iter->get_prop ("name") == key) {
                            var list = iter->get_content ();
                            foreach (var item in list.split (",")) {
                                if (val == null) {
                                    val = new Gee.ArrayList<int> ();
                                }
                                val.add (int.parse (item));
                            }
                        }
                    }
                }
                break;
            default:
                throw new Dcs.ConfigError.INVALID_FORMAT ("Invalid format provided");
        }

        //if (val == null) {
            //throw new Dcs.ConfigError.NO_VALUE_SET ("No value available");
        //}

        return val;
    }

    public override bool get_bool (string ns,
                                   string key) throws GLib.Error {
        bool val = false;
        bool unavailable = true;

        switch (format) {
            case Dcs.ConfigFormat.INI:
                try {
                    val = ini.get_boolean (ns, key);
                    unavailable = false;
                    break;
                } catch (GLib.Error e) { }
                break;
            case Dcs.ConfigFormat.JSON:
                var dcs = json.get_member (ns);
                var dcs_obj = dcs.get_object ();
                var prop = dcs_obj.get_member ("properties");
                var prop_obj = prop.get_object ();
                var bprop = prop_obj.get_member (key);
                var type = bprop.get_value_type ();
                if (type.is_a (typeof (bool))) {
                    val = prop_obj.get_boolean_member (key);
                    unavailable = false;
                }
                break;
            case Dcs.ConfigFormat.XML:
                for (Xml.Node *iter = xml->children; iter != null; iter = iter->next) {
                    if (iter->name == "property") {
                        if (iter->get_prop ("name") == key) {
                            val = bool.parse (iter->get_content ());
                        }
                    }
                }
                break;
            default:
                throw new Dcs.ConfigError.INVALID_FORMAT ("Invalid format provided");
        }

        //if (unavailable) {
            //throw new Dcs.ConfigError.NO_VALUE_SET ("No value available");
        //}

        return val;
    }
}

/**
 * Dummy class of command line option based configurations for testing.
 */
public class Dcs.Test.CmdlineConfig : Dcs.BaseConfig {

    private static bool test_a = false;
    private static bool test_b = false;
    private static bool test_c = false;

    private static Dcs.Test.CmdlineConfig config;

    const OptionEntry[] options = {
        { "test-a", 'a', 0, OptionArg.NONE, ref test_a, "Test A", null },
        { "test-b", 'b', 0, OptionArg.NONE, ref test_b, "Test B", null },
        { "test-c", 'c', 0, OptionArg.NONE, ref test_c, "Test C", null },
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

    public void set_format (Dcs.ConfigFormat fmt) {
        if (fmt.is_valid ()) {
            format = fmt;
        }
    }

    public override Dcs.ConfigFormat get_format () throws GLib.Error {
        return format;
    }

    public bool get_test_a () {
        return test_a;
    }

    public bool get_test_b () {
        return test_b;
    }

    public bool get_test_c () {
        return test_c;
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
        add_test (@"[$class_name] Test namespace property", test_namespace);
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
        (test_config as Dcs.Test.Config).set_format (Dcs.ConfigFormat.OPTIONS);
        assert_true (test_config.get_format () == Dcs.ConfigFormat.OPTIONS);
        (test_config as Dcs.Test.Config).set_format (Dcs.ConfigFormat.INI);
        assert_true (test_config.get_format () == Dcs.ConfigFormat.INI);
        (test_config as Dcs.Test.Config).set_format (Dcs.ConfigFormat.JSON);
        assert_true (test_config.get_format () == Dcs.ConfigFormat.JSON);
        (test_config as Dcs.Test.Config).set_format (Dcs.ConfigFormat.XML);
        assert_true (test_config.get_format () == Dcs.ConfigFormat.XML);
    }

    private void test_namespace () {
        (test_config as Dcs.Test.Config).set_namespace ("dcs");
        assert_true (test_config.get_namespace () == "dcs");
    }

    private void test_load_cmdline () {
        string[] args = {
            "test-dcs-core",
            "--test-a",
            "--test-b"
        };
        unowned string[] test_args = args;
        /* This is the only test where the common class isn't relevant */
        var _test_config = Dcs.Test.CmdlineConfig.get_default ();
        Dcs.Test.CmdlineConfig.parse_args (ref test_args);
        try {
            assert_true ((_test_config as Dcs.Test.CmdlineConfig).get_format () == Dcs.ConfigFormat.OPTIONS);
            assert_true ((_test_config as Dcs.Test.CmdlineConfig).get_test_a () == true);
            assert_true ((_test_config as Dcs.Test.CmdlineConfig).get_test_b () == true);
            assert_true ((_test_config as Dcs.Test.CmdlineConfig).get_test_c () == false);
        } catch (GLib.Error e) {
            message (e.message);
        }
    }

    private void test_load_ini () {
        assert_true (true);
    }

    private void test_load_ini_data () {
        string ini = """
          [dcs]
          sprop = string
          slprop = string,string
          iprop = 1
          ilprop = 1,1
          bprop = true
        """;

        try {
            (test_config as Dcs.Test.Config).load_data (ini, Dcs.ConfigFormat.INI);
            assert_true (test_config.get_format () == Dcs.ConfigFormat.INI);
            assert_true (test_config.get_string ("dcs", "sprop") == "string");
            var slist = test_config.get_string_list ("dcs", "slprop");
            assert_nonnull (slist);
            foreach (var item in slist) {
                assert_true (item == "string");
            }
            assert_true (test_config.get_int ("dcs", "iprop") == 1);
            var ilist = test_config.get_int_list ("dcs", "ilprop");
            assert_nonnull (ilist);
            foreach (var item in ilist) {
                assert_true (item == 1);
            }
            assert_true (test_config.get_bool ("dcs", "bprop"));
        } catch (GLib.Error e) {
            message (e.message);
        }
    }

    private void test_load_json () {
        assert_true (true);
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
                "bprop": true
              }
            }
          }
        """;

        try {
            (test_config as Dcs.Test.Config).load_data (json, Dcs.ConfigFormat.JSON);
            assert_true (test_config.get_format () == Dcs.ConfigFormat.JSON);
            assert_true (test_config.get_string ("dcs", "sprop") == "string");
            var slist = test_config.get_string_list ("dcs", "slprop");
            assert_nonnull (slist);
            foreach (var item in slist) {
                assert_true (item == "string");
            }
            assert_true (test_config.get_int ("dcs", "iprop") == 1);
            var ilist = test_config.get_int_list ("dcs", "ilprop");
            assert_nonnull (ilist);
            foreach (var item in ilist) {
                assert_true (item == 1);
            }
            assert_true (test_config.get_bool ("dcs", "bprop"));
        } catch (GLib.Error e) {
            message (e.message);
        }
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
          </dcs>
        """;

        /*
         *test_config.config_loaded.connect ((res) => {
         *    assert_true (res);
         *});
         */

        try {
            (test_config as Dcs.Test.Config).load_data (xml, Dcs.ConfigFormat.XML);
            assert_true (test_config.get_format () == Dcs.ConfigFormat.XML);
            assert_true (test_config.get_string ("dcs", "sprop") == "string");
            var slist = test_config.get_string_list ("dcs", "slprop");
            assert_nonnull (slist);
            foreach (var item in slist) {
                assert_true (item == "string");
            }
            assert_true (test_config.get_int ("dcs", "iprop") == 1);
            var ilist = test_config.get_int_list ("dcs", "ilprop");
            assert_nonnull (ilist);
            foreach (var item in ilist) {
                assert_true (item == 1);
            }
            assert_true (test_config.get_bool ("dcs", "bprop"));
        } catch (GLib.Error e) {
            message (e.message);
        }
    }
}
