public abstract class Dcs.ConfigNodeTestsBase : Dcs.TestCase {

    protected Dcs.ConfigNode xml;

    protected Dcs.ConfigNode json;

    public ConfigNodeTestsBase (string name) {
        base (name);
    }
}

public class Dcs.ConfigNodeTests : Dcs.ConfigNodeTestsBase {

    private const string class_name = "DcsConfigNode";

    public ConfigNodeTests () {
        base (class_name);
        /*
         *[> Testing format and namespace seems redundant <]
         *add_test (@"[$class_name] Test format property", test_format);
         *add_test (@"[$class_name] Test namespace property", test_namespace);
         */
        add_test (@"[$class_name] Test load from JSON node", test_load_json);
        add_test (@"[$class_name] Test JSON get string", test_json_get_string);
        add_test (@"[$class_name] Test JSON get string list", test_json_get_string_list);
        add_test (@"[$class_name] Test JSON get int", test_json_get_int);
        add_test (@"[$class_name] Test JSON get int list", test_json_get_int_list);
        add_test (@"[$class_name] Test JSON get boolean", test_json_get_boolean);
        add_test (@"[$class_name] Test JSON get boolean list", test_json_get_boolean_list);
        add_test (@"[$class_name] Test JSON get double", test_json_get_double);
        add_test (@"[$class_name] Test JSON get double list", test_json_get_double_list);
        add_test (@"[$class_name] Test JSON set string", test_json_set_string);
        add_test (@"[$class_name] Test JSON set string list", test_json_set_string_list);
        add_test (@"[$class_name] Test JSON set int", test_json_set_int);
        add_test (@"[$class_name] Test JSON set int list", test_json_set_int_list);
        add_test (@"[$class_name] Test JSON set boolean", test_json_set_boolean);
        add_test (@"[$class_name] Test JSON set boolean list", test_json_set_boolean_list);
        add_test (@"[$class_name] Test JSON set double", test_json_set_double);
        add_test (@"[$class_name] Test JSON set double list", test_json_set_double_list);
        add_test (@"[$class_name] Test load from XML node", test_load_xml);
        add_test (@"[$class_name] Test XML get string", test_xml_get_string);
        add_test (@"[$class_name] Test XML get string list", test_xml_get_string_list);
        add_test (@"[$class_name] Test XML get int", test_xml_get_int);
        add_test (@"[$class_name] Test XML get int list", test_xml_get_int_list);
        add_test (@"[$class_name] Test XML get boolean", test_xml_get_boolean);
        add_test (@"[$class_name] Test XML get boolean list", test_xml_get_boolean_list);
        add_test (@"[$class_name] Test XML get double", test_xml_get_double);
        add_test (@"[$class_name] Test XML get double list", test_xml_get_double_list);
        add_test (@"[$class_name] Test XML set string", test_xml_set_string);
        add_test (@"[$class_name] Test XML set string list", test_xml_set_string_list);
        add_test (@"[$class_name] Test XML set int", test_xml_set_int);
        add_test (@"[$class_name] Test XML set int list", test_xml_set_int_list);
        add_test (@"[$class_name] Test XML set boolean", test_xml_set_boolean);
        add_test (@"[$class_name] Test XML set boolean list", test_xml_set_boolean_list);
        add_test (@"[$class_name] Test XML set double", test_xml_set_double);
        add_test (@"[$class_name] Test XML set double list", test_xml_set_double_list);
        add_test (@"[$class_name] Test node format conversion", test_convert);
    }

    public override void set_up () {
        string json_data = """
          {
            "obj0": {
              "type": "object",
              "properties": {
                "sprop": "string",
                "slprop": ["string","string"],
                "iprop": 1,
                "ilprop": [1,1],
                "bprop": true,
                "blprop": [true,true],
                "dprop": 1.0,
                "dlprop": [1.1,1.1]
              }
            }
          }
        """;

        var parser = new Json.Parser ();
        try {
            parser.load_from_data (json_data);
        } catch (GLib.Error e) {
            debug (e.message);
        }

        var json_node = parser.get_root ();
        json = new Dcs.ConfigNode.from_json (json_node);

        string xml_data = """
          <object type="object" id="obj0">
            <property name="sprop">string</property>
            <property name="slprop">string,string</property>
            <property name="iprop">1</property>
            <property name="ilprop">1,1</property>
            <property name="bprop">true</property>
            <property name="blprop">true,true</property>
            <property name="dprop">1.0</property>
            <property name="dlprop">1.1,1.1</property>
          </object>
        """;

        Xml.Doc *doc = Xml.Parser.parse_memory (xml_data, xml_data.length);
        Xml.XPath.Context *ctx = new Xml.XPath.Context (doc);
        Xml.XPath.Object *obj = ctx->eval_expression ("/object");
        assert_nonnull (obj);

        var xml_node = obj->nodesetval->item (0);
        xml = new Dcs.ConfigNode.from_xml (xml_node);
    }

    public override void tear_down () {
        json = null;
        xml = null;
    }

    private void test_load_json () {
        assert_nonnull (json);
        assert (json.get_format () == Dcs.ConfigFormat.JSON);
        //json.dump (stdout);
    }

    private void test_load_xml () {
        assert_nonnull (xml);
        assert (xml.get_format () == Dcs.ConfigFormat.XML);
        //xml.dump (stdout);
    }

    private void test_convert () {
        /* This functionality doesn't exist yet */
        assert (true);
    }

	private void test_json_get_string () {
        assert (json.get_format () == Dcs.ConfigFormat.JSON);
        try {
            assert (json.get_string ("obj0", "sprop") == "string");
        } catch (GLib.Error e) {
            assert (!(e is Dcs.ConfigError));
        }
	}

	private void test_json_get_string_list () {
        assert (json.get_format () == Dcs.ConfigFormat.JSON);
        try {
            var list = json.get_string_list ("obj0", "slprop");
            assert_nonnull (list);
            foreach (var item in list) {
                assert (item == "string");
            }
        } catch (GLib.Error e) {
            assert (!(e is Dcs.ConfigError));
        }
	}

	private void test_json_get_int () {
        assert (json.get_format () == Dcs.ConfigFormat.JSON);
        try {
            assert (json.get_int ("obj0", "iprop") == 1);
        } catch (GLib.Error e) {
            assert (!(e is Dcs.ConfigError));
        }
	}

	private void test_json_get_int_list () {
        assert (json.get_format () == Dcs.ConfigFormat.JSON);
        try {
            var list = json.get_int_list ("obj0", "ilprop");
            assert_nonnull (list);
            foreach (var item in list) {
                assert (item == 1);
            }
        } catch (GLib.Error e) {
            assert (!(e is Dcs.ConfigError));
        }
	}

	private void test_json_get_boolean () {
        assert (json.get_format () == Dcs.ConfigFormat.JSON);
        try {
            assert (json.get_bool ("obj0", "bprop") == true);
        } catch (GLib.Error e) {
            assert (!(e is Dcs.ConfigError));
        }
	}

	private void test_json_get_boolean_list () {
        assert (json.get_format () == Dcs.ConfigFormat.JSON);
        try {
            var list = json.get_bool_list ("obj0", "blprop");
            assert_nonnull (list);
            foreach (var item in list) {
                assert (item == true);
            }
        } catch (GLib.Error e) {
            assert (!(e is Dcs.ConfigError));
        }
	}

	private void test_json_get_double () {
        assert (json.get_format () == Dcs.ConfigFormat.JSON);
        try {
            assert (json.get_double ("obj0", "dprop") == 1.0);
        } catch (GLib.Error e) {
            assert (!(e is Dcs.ConfigError));
        }
	}

	private void test_json_get_double_list () {
        assert (json.get_format () == Dcs.ConfigFormat.JSON);
        try {
            var list = json.get_double_list ("obj0", "dlprop");
            assert_nonnull (list);
            foreach (var item in list) {
                assert (item == 1.1);
            }
        } catch (GLib.Error e) {
            assert (!(e is Dcs.ConfigError));
        }
	}

	private void test_json_set_string () {
        assert (json.get_format () == Dcs.ConfigFormat.JSON);
        try {
            json.set_string ("obj0", "sprop", "test");
            assert (json.get_string ("obj0", "sprop") == "test");
        } catch (GLib.Error e) {
            assert (!(e is Dcs.ConfigError));
        }
	}

	private void test_json_set_string_list () {
        assert (json.get_format () == Dcs.ConfigFormat.JSON);
        try {
            string[] value = { "test", "test" };
            json.set_string_list ("obj0", "slprop", value);
            var list = json.get_string_list ("obj0", "slprop");
            foreach (var item in list) {
                assert (item == "test");
            }
        } catch (GLib.Error e) {
            assert (!(e is Dcs.ConfigError));
        }
	}

	private void test_json_set_int () {
        assert (json.get_format () == Dcs.ConfigFormat.JSON);
        try {
            json.set_int ("obj0", "iprop", 2);
            assert (json.get_int ("obj0", "iprop") == 2);
        } catch (GLib.Error e) {
            assert (!(e is Dcs.ConfigError));
        }
	}

	private void test_json_set_int_list () {
        assert (json.get_format () == Dcs.ConfigFormat.JSON);
        try {
            int[] value = { 2, 2 };
            json.set_int_list ("obj0", "ilprop", value);
            var list = json.get_int_list ("obj0", "ilprop");
            foreach (var item in list) {
                assert (item == 2);
            }
        } catch (GLib.Error e) {
            assert (!(e is Dcs.ConfigError));
        }
	}

	private void test_json_set_boolean () {
        assert (json.get_format () == Dcs.ConfigFormat.JSON);
        try {
            json.set_bool ("obj0", "bprop", false);
            assert (json.get_bool ("obj0", "bprop") == false);
        } catch (GLib.Error e) {
            assert (!(e is Dcs.ConfigError));
        }
	}

	private void test_json_set_boolean_list () {
        assert (json.get_format () == Dcs.ConfigFormat.JSON);
        try {
            bool[] value = { false, false };
            json.set_bool_list ("obj0", "blprop", value);
            var list = json.get_bool_list ("obj0", "blprop");
            foreach (var item in list) {
                assert (item == false);
            }
        } catch (GLib.Error e) {
            assert (!(e is Dcs.ConfigError));
        }
	}

	private void test_json_set_double () {
        assert (json.get_format () == Dcs.ConfigFormat.JSON);
        try {
            json.set_double ("obj0", "dprop", 2.0);
            assert (json.get_double ("obj0", "dprop") == 2.0);
        } catch (GLib.Error e) {
            assert (!(e is Dcs.ConfigError));
        }
	}

	private void test_json_set_double_list () {
        assert (json.get_format () == Dcs.ConfigFormat.JSON);
        try {
            double[] value = { 2.2, 2.2 };
            json.set_double_list ("obj0", "dlprop", value);
            var list = json.get_double_list ("obj0", "dlprop");
            foreach (var item in list) {
                assert (item == 2.2);
            }
        } catch (GLib.Error e) {
            assert (!(e is Dcs.ConfigError));
        }
	}

	private void test_xml_get_string () {
        assert (xml.get_format () == Dcs.ConfigFormat.XML);
        try {
            assert (xml.get_string ("obj0", "sprop") == "string");
        } catch (GLib.Error e) {
            assert (!(e is Dcs.ConfigError));
        }
	}

	private void test_xml_get_string_list () {
        assert (xml.get_format () == Dcs.ConfigFormat.XML);
        try {
            var list = xml.get_string_list ("obj0", "slprop");
            assert_nonnull (list);
            foreach (var item in list) {
                assert (item == "string");
            }
        } catch (GLib.Error e) {
            assert (!(e is Dcs.ConfigError));
        }
	}

	private void test_xml_get_int () {
        assert (xml.get_format () == Dcs.ConfigFormat.XML);
        try {
            assert (xml.get_int ("obj0", "iprop") == 1);
        } catch (GLib.Error e) {
            assert (!(e is Dcs.ConfigError));
        }
	}

	private void test_xml_get_int_list () {
        assert (xml.get_format () == Dcs.ConfigFormat.XML);
        try {
            var list = xml.get_int_list ("obj0", "ilprop");
            assert_nonnull (list);
            foreach (var item in list) {
                assert (item == 1);
            }
        } catch (GLib.Error e) {
            assert (!(e is Dcs.ConfigError));
        }
	}

	private void test_xml_get_boolean () {
        assert (xml.get_format () == Dcs.ConfigFormat.XML);
        try {
            assert (xml.get_bool ("obj0", "bprop") == true);
        } catch (GLib.Error e) {
            assert (!(e is Dcs.ConfigError));
        }
	}

	private void test_xml_get_boolean_list () {
        assert (xml.get_format () == Dcs.ConfigFormat.XML);
        try {
            var list = xml.get_bool_list ("obj0", "blprop");
            assert_nonnull (list);
            foreach (var item in list) {
                assert (item == true);
            }
        } catch (GLib.Error e) {
            assert (!(e is Dcs.ConfigError));
        }
	}

	private void test_xml_get_double () {
        assert (xml.get_format () == Dcs.ConfigFormat.XML);
        try {
            assert (xml.get_double ("obj0", "dprop") == 1.0);
        } catch (GLib.Error e) {
            assert (!(e is Dcs.ConfigError));
        }
	}

	private void test_xml_get_double_list () {
        assert (xml.get_format () == Dcs.ConfigFormat.XML);
        try {
            var list = xml.get_double_list ("obj0", "dlprop");
            assert_nonnull (list);
            foreach (var item in list) {
                assert (item == 1.1);
            }
        } catch (GLib.Error e) {
            assert (!(e is Dcs.ConfigError));
        }
	}

	private void test_xml_set_string () {
        assert (xml.get_format () == Dcs.ConfigFormat.XML);
        try {
            xml.set_string ("obj0", "sprop", "test");
            assert (xml.get_string ("obj0", "sprop") == "test");
        } catch (GLib.Error e) {
            assert (!(e is Dcs.ConfigError));
        }
	}

	private void test_xml_set_string_list () {
        assert (xml.get_format () == Dcs.ConfigFormat.XML);
        try {
            string[] value = { "test", "test" };
            xml.set_string_list ("obj0", "slprop", value);
            var list = xml.get_string_list ("obj0", "slprop");
            foreach (var item in list) {
                assert (item == "test");
            }
        } catch (GLib.Error e) {
            assert (!(e is Dcs.ConfigError));
        }
	}

	private void test_xml_set_int () {
        assert (xml.get_format () == Dcs.ConfigFormat.XML);
        try {
            xml.set_int ("obj0", "iprop", 2);
            assert (xml.get_int ("obj0", "iprop") == 2);
        } catch (GLib.Error e) {
            assert (!(e is Dcs.ConfigError));
        }
	}

	private void test_xml_set_int_list () {
        assert (xml.get_format () == Dcs.ConfigFormat.XML);
        try {
            int[] value = { 2, 2 };
            xml.set_int_list ("obj0", "ilprop", value);
            var list = xml.get_int_list ("obj0", "ilprop");
            foreach (var item in list) {
                assert (item == 2);
            }
        } catch (GLib.Error e) {
            assert (!(e is Dcs.ConfigError));
        }
	}

	private void test_xml_set_boolean () {
        assert (xml.get_format () == Dcs.ConfigFormat.XML);
        try {
            xml.set_bool ("obj0", "bprop", false);
            assert (xml.get_bool ("obj0", "bprop") == false);
        } catch (GLib.Error e) {
            assert (!(e is Dcs.ConfigError));
        }
	}

	private void test_xml_set_boolean_list () {
        assert (xml.get_format () == Dcs.ConfigFormat.XML);
        try {
            bool[] value = { false, false };
            xml.set_bool_list ("obj0", "blprop", value);
            var list = xml.get_bool_list ("obj0", "blprop");
            foreach (var item in list) {
                assert (item == false);
            }
        } catch (GLib.Error e) {
            assert (!(e is Dcs.ConfigError));
        }
	}

	private void test_xml_set_double () {
        assert (xml.get_format () == Dcs.ConfigFormat.XML);
        try {
            xml.set_double ("obj0", "dprop", 2.0);
            assert (xml.get_double ("obj0", "dprop") == 2.0);
        } catch (GLib.Error e) {
            assert (!(e is Dcs.ConfigError));
        }
	}

	private void test_xml_set_double_list () {
        assert (xml.get_format () == Dcs.ConfigFormat.XML);
        try {
            double[] value = { 2.2, 2.2 };
            xml.set_double_list ("obj0", "dlprop", value);
            var list = xml.get_double_list ("obj0", "dlprop");
            foreach (var item in list) {
                assert (item == 2.2);
            }
        } catch (GLib.Error e) {
            assert (!(e is Dcs.ConfigError));
        }
	}
}
