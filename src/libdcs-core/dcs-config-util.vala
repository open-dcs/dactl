/**
 * Utility methods to work with JSON configuration data.
 *
 * TODO do the documentation for the methods
 * TODO make every method throw an exception
 * TODO find out what's preventing the namespace pull on JSON loads
 * TODO Make all of the json_/xml_ get/set methods below internal. It is
 * apparently possible to do this and still have them accessible to other
 * libraries by generating an internal header and vapi.
 */
namespace Dcs.ConfigJson {

    /**
     * TODO fill me in
     */
    public static Json.Node load_data (string data)
                                       throws GLib.Error {
        var parser = new Json.Parser ();

        try {
            parser.load_from_data (data);
        } catch (GLib.Error e) {
            throw e;
        }

        /*
         *var node = parser.get_root ();
         *var obj = node.get_object ();
         *return obj.get_member ("dcs");
         */
        return parser.get_root ();
    }

    /**
     * TODO fill me in
     */
    public static Json.Node load_file (string filename)
                                       throws GLib.Error {
        if (!FileUtils.test (filename, FileTest.EXISTS)) {
            throw new Dcs.ConfigError.FILE_NOT_FOUND (
                "The file %s does not exist", filename);
        }

        var parser = new Json.Parser ();

        try {
            parser.load_from_file (filename);
        } catch (GLib.Error e) {
            throw e;
        }

        return parser.get_root ();
    }

    public static Gee.List<Json.Node> get_child_nodes (Json.Node node) {
        var obj = node.get_object ();
        var ns = obj.get_members ().nth_data (0);
        var data = obj.get_object_member (ns);
        var children = new Gee.ArrayList<Json.Node> ();

        if (data.has_member ("objects")) {
            var objects = data.get_object_member ("objects");
            foreach (var name in objects.get_members ()) {
                var builder = new Json.Builder ();
                builder.begin_object ();
                builder.set_member_name (name);
                builder.add_value (objects.get_member (name));
                builder.end_object ();
                children.add (builder.get_root ());
            }
        }

        return children;
    }

    /**
     * TODO fill me in
     */
    public static string get_string (Json.Node node,
                                     string key) {
        var obj = node.get_object ();
        var ns = obj.get_members ().nth_data (0);
        var data = obj.get_object_member (ns);
        var prop = data.get_member ("properties");
        var prop_obj = prop.get_object ();
        var sprop = prop_obj.get_member (key);
        var type = sprop.get_value_type ();

        if (type.is_a (typeof (string))) {
            return prop_obj.get_string_member (key);
        }

        return null;
    }

    /**
     * TODO fill me in
     */
    public static Gee.ArrayList<string> get_string_list (Json.Node node,
                                                         string key) {
        Gee.ArrayList<string> val = null;

        var obj = node.get_object ();
        var ns = obj.get_members ().nth_data (0);
        var data = obj.get_object_member (ns);
        var prop = data.get_member ("properties");
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

        return val;
    }

    /**
     * TODO fill me in
     */
    public static int get_int (Json.Node node,
                               string key) throws GLib.Error {
        int val = 0;
        bool unavailable = true;

        var obj = node.get_object ();
        var ns = obj.get_members ().nth_data (0);
        var data = obj.get_object_member (ns);
        var prop = data.get_member ("properties");
        var prop_obj = prop.get_object ();
        var iprop = prop_obj.get_member (key);
        var type = iprop.get_value_type ();

        if (type.is_a (typeof (int64))) {
            val = (int) prop_obj.get_int_member (key);
            unavailable = false;
        }

        if (unavailable) {
            throw new Dcs.ConfigError.NO_VALUE_SET (
                "No property was found with key " + key);
        }

        return val;
    }

    /**
     * TODO fill me in
     */
    public static Gee.ArrayList<int> get_int_list (Json.Node node,
                                                   string key) {
        Gee.ArrayList<int> val = null;

        var obj = node.get_object ();
        var ns = obj.get_members ().nth_data (0);
        var data = obj.get_object_member (ns);
        var prop = data.get_member ("properties");
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

        return val;
    }

    /**
     * TODO fill me in
     */
    public static bool get_bool (Json.Node node,
                                 string key) throws GLib.Error {
        bool val = false;
        bool unavailable = true;

        var obj = node.get_object ();
        var ns = obj.get_members ().nth_data (0);
        var data = obj.get_object_member (ns);
        var prop = data.get_member ("properties");
        var prop_obj = prop.get_object ();
        var bprop = prop_obj.get_member (key);
        var type = bprop.get_value_type ();

        if (type.is_a (typeof (bool))) {
            val = (bool) prop_obj.get_boolean_member (key);
            unavailable = false;
        }

        if (unavailable) {
            throw new Dcs.ConfigError.NO_VALUE_SET (
                "No property was found with key " + key);
        }

        return val;
    }

    /**
     * TODO fill me in
     */
    public static double get_double (Json.Node node,
                                     string key) throws GLib.Error {
        double val = 0.0;
        bool unavailable = true;

        var obj = node.get_object ();
        var ns = obj.get_members ().nth_data (0);
        var data = obj.get_object_member (ns);
        var prop = data.get_member ("properties");
        var prop_obj = prop.get_object ();
        var dprop = prop_obj.get_member (key);
        var type = dprop.get_value_type ();

        if (type.is_a (typeof (double))) {
            val = (double) prop_obj.get_double_member (key);
            unavailable = false;
        }

        if (unavailable) {
            throw new Dcs.ConfigError.NO_VALUE_SET (
                "No property was found with key " + key);
        }

        return val;
    }

    /**
     * TODO fill me in
     */
    public static void set_string (Json.Node node,
                                   string key,
                                   string value) {
		var obj = node.get_object ();
        var ns = obj.get_members ().nth_data (0);
        var data = obj.get_object_member (ns);
		var prop = data.get_member ("properties");
		var prop_obj = prop.get_object ();
		prop_obj.set_string_member (key, value);
    }

    /**
     * TODO fill me in
     */
    public static void set_int (Json.Node node,
                                string key,
                                int value) {
		var obj = node.get_object ();
        var ns = obj.get_members ().nth_data (0);
        var data = obj.get_object_member (ns);
		var prop = data.get_member ("properties");
		var prop_obj = prop.get_object ();
		prop_obj.set_int_member (key, (int64) value);
    }

    /**
     * TODO fill me in
     */
    public static void set_bool (Json.Node node,
                                 string key,
                                 bool value) {
		var obj = node.get_object ();
        var ns = obj.get_members ().nth_data (0);
        var data = obj.get_object_member (ns);
		var prop = data.get_member ("properties");
		var prop_obj = prop.get_object ();
		prop_obj.set_boolean_member (key, value);
    }

    /**
     * TODO fill me in
     */
    public static void set_double (Json.Node node,
                                   string key,
                                   double value) {
		var obj = node.get_object ();
        var ns = obj.get_members ().nth_data (0);
        var data = obj.get_object_member (ns);
		var prop = data.get_member ("properties");
		var prop_obj = prop.get_object ();
		prop_obj.set_double_member (key, value);
    }
}

/**
 * Utility methods to work with XML configuration data.
 */
namespace Dcs.ConfigXml {

    /**
     * TODO fill me in
     */
    public static Xml.Node* load_data (string data,
                                       string ns)
                                       throws GLib.Error {
        Xml.Doc *doc = Xml.Parser.parse_memory (data, data.length);
        Xml.XPath.Context *ctx = new Xml.XPath.Context (doc);
        var ns_urn = "urn:libdcs";
        var path = "/" + ns;

        ns_urn += (ns == "dcs") ? ns_urn : ("-" + ns);
        ctx->register_ns (ns, ns_urn);
        Xml.XPath.Object *obj = ctx->eval_expression (path);

        if (obj == null) {
            throw new Dcs.ConfigError.INVALID_XPATH_EXPR (
                "The XPath expression \"%s\" is not valid", path);
        }

        return obj->nodesetval->item (0);
    }

    /**
     * TODO fill me in
     */
    public static Xml.Node* load_file (string filename,
                                       string ns)
                                       throws GLib.Error {
        if (!FileUtils.test (filename, FileTest.EXISTS)) {
            throw new Dcs.ConfigError.FILE_NOT_FOUND (
                "The file %s does not exist", filename);
        }

        Xml.Doc *doc = Xml.Parser.parse_file (filename);
        Xml.XPath.Context *ctx = new Xml.XPath.Context (doc);
        var ns_urn = "urn:libdcs";
        var path = "/" + ns;

        ns_urn += (ns == "dcs") ? ns_urn : ("-" + ns);
        ctx->register_ns (ns, ns_urn);
        Xml.XPath.Object *obj = ctx->eval_expression (path);

        if (obj == null) {
            throw new Dcs.ConfigError.INVALID_XPATH_EXPR (
                "The XPath expression \"%s\" is not valid", path);
        }

        return obj->nodesetval->item (0);
    }

    public static Gee.List<Xml.Node*> get_child_nodes (Xml.Node* node) {
        var children = new Gee.ArrayList<Xml.Node*> ();

        for (Xml.Node *iter = node->children; iter != null; iter = iter->next) {
            if (iter->name == "object") {
                children.add (iter);
            }
        }

        return children;
    }

    /**
     * TODO fill me in
     */
    public static string get_string (Xml.Node* node, string key) {
        string val = null;

        for (Xml.Node *iter = node->children; iter != null; iter = iter->next) {
            if (iter->name == "property") {
                if (iter->get_prop ("name") == key) {
                    val = iter->get_content ();
                }
            }
        }

        return val;
    }

    /**
     * TODO fill me in
     */
    public static Gee.ArrayList<string> get_string_list (Xml.Node* node,
                                                         string key) {
        Gee.ArrayList<string> val = null;

        for (Xml.Node *iter = node->children; iter != null; iter = iter->next) {
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

        return val;
    }

    /**
     * TODO fill me in
     */
    public static int get_int (Xml.Node* node,
                               string key) throws GLib.Error {
        int val = 0;
        bool unavailable = true;

        for (Xml.Node *iter = node->children; iter != null; iter = iter->next) {
            if (iter->name == "property") {
                if (iter->get_prop ("name") == key) {
                    val = int.parse (iter->get_content ());
                    unavailable = false;
                }
            }
        }

        if (unavailable) {
            throw new Dcs.ConfigError.NO_VALUE_SET (
                "No property was found with key " + key);
        }

        return val;
    }

    /**
     * TODO fill me in
     */
    public static Gee.ArrayList<int> get_int_list (Xml.Node* node,
                                                   string key) {
        Gee.ArrayList<int> val = null;

        for (Xml.Node *iter = node->children; iter != null; iter = iter->next) {
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

        return val;
    }

    /**
     * TODO fill me in
     */
    public static bool get_bool (Xml.Node* node,
                                 string key) throws GLib.Error {
        bool val = false;
        bool unavailable = true;

        for (Xml.Node *iter = node->children; iter != null; iter = iter->next) {
            if (iter->name == "property") {
                if (iter->get_prop ("name") == key) {
                    val = bool.parse (iter->get_content ());
                    unavailable = false;
                }
            }
        }

        if (unavailable) {
            throw new Dcs.ConfigError.NO_VALUE_SET (
                "No property was found with key " + key);
        }

        return val;
    }

    /**
     * TODO fill me in
     */
    public static double get_double (Xml.Node* node,
                                     string key) throws GLib.Error {
        double val = 0.0;
        bool unavailable = true;

        for (Xml.Node *iter = node->children; iter != null; iter = iter->next) {
            if (iter->name == "property") {
                if (iter->get_prop ("name") == key) {
                    val = double.parse (iter->get_content ());
                    unavailable = false;
                }
            }
        }

        if (unavailable) {
            throw new Dcs.ConfigError.NO_VALUE_SET (
                "No property was found with key " + key);
        }

        return val;
    }

    /**
     * TODO fill me in
     */
    public static void set_string (Xml.Node* node,
                                   string key,
                                   string value) {
		for (Xml.Node *iter = node->children; iter != null; iter = iter->next) {
			if (iter->name == "property") {
				if (iter->get_prop ("name") == key) {
					iter->set_content (value);
				}
			}
		}
    }

    /**
     * TODO fill me in
     */
    public static void set_int (Xml.Node* node,
                                string key,
                                int value) {
		for (Xml.Node *iter = node->children; iter != null; iter = iter->next) {
			if (iter->name == "property") {
				if (iter->get_prop ("name") == key) {
					iter->set_content (value.to_string ());
				}
			}
		}
    }

    /**
     * TODO fill me in
     */
    public static void set_bool (Xml.Node* node,
                                 string key,
                                 bool value) {
		for (Xml.Node *iter = node->children; iter != null; iter = iter->next) {
			if (iter->name == "property") {
				if (iter->get_prop ("name") == key) {
					iter->set_content (value.to_string ());
				}
			}
		}
    }

    /**
     * TODO fill me in
     */
    public static void set_double (Xml.Node* node,
                                   string key,
                                   double value) {
		for (Xml.Node *iter = node->children; iter != null; iter = iter->next) {
			if (iter->name == "property") {
				if (iter->get_prop ("name") == key) {
					iter->set_content (value.to_string ());
				}
			}
		}
    }
}
