/**
 * Mock object to instantiate an abstract class for testing.
 */
public class Dcs.Test.Config : Dcs.BaseConfig {

    private KeyFile ini;

    private Json.Node json;

    private Xml.Node *xml;

    /**
     * XXX In a class that actually implements this functionality this should
     *     be a constructor with a .from_data (...).
     */
    public void load_data (string data, Dcs.ConfigFormat format)
                           throws GLib.Error {
        this.format = format;
        switch (format) {
            case Dcs.ConfigFormat.INI:
                load_ini_data (data);
                break;
            case Dcs.ConfigFormat.JSON:
                load_json_data (data);
                break;
            case Dcs.ConfigFormat.XML:
                try {
                    load_xml_data (data);
                } catch (GLib.Error e) {
                    throw e;
                }
                break;
            default:
                throw new Dcs.ConfigError.INVALID_FORMAT ("Invalid format provided");
                break;
        }
    }

    private void load_ini_data (string data) {
        if (ini != null) {
            ini = null;
        }

        try {
            ini = new KeyFile ();
            ini.set_list_separator (',');
            ini.load_from_data (data, -1, KeyFileFlags.NONE);
        } catch (GLib.Error e) {
            throw e;
        }
    }

    private void load_json_data (string data) {
        if (json != null) {
            json = null;
        }

        var parser = new Json.Parser ();
        try {
            parser.load_from_data (data);
        } catch (GLib.Error e) {
            throw e;
        }

        json = parser.get_root ();
    }

    private void load_xml_data (string data) throws GLib.Error {
        if (xml != null) {
            xml = null;
        }

        Xml.Doc *doc = Xml.Parser.parse_memory (data, data.length);
        Xml.XPath.Context *ctx = new Xml.XPath.Context (doc);
        ctx->register_ns ("dcs", "urn:libdcs");
        //xml = doc->get_root_element ();
        Xml.XPath.Object *obj = ctx->eval_expression ("/dcs");
        if (obj == null) {
            throw new Dcs.ConfigError.INVALID_XPATH_EXPR (
                "The XPath expression \"/dcs\" didn't work.");
        }
        xml = obj->nodesetval->item (0);
    }

    /**
     * XXX In a class that actually implements this functionality this should
     *     be a constructor with a .from_file (...).
     */
    public void load_file (string filename, Dcs.ConfigFormat format)
                           throws GLib.Error {
        this.format = format;
        switch (format) {
            case Dcs.ConfigFormat.INI:
                load_ini_file (filename);
                break;
            case Dcs.ConfigFormat.JSON:
                load_json_file (filename);
                break;
            case Dcs.ConfigFormat.XML:
                load_xml_file (filename);
                break;
            default:
                throw new Dcs.ConfigError.INVALID_FORMAT ("Invalid format provided");
                break;
        }
    }

    private void load_ini_file (string filename) {
        if (ini != null) {
            ini = null;
        }

        try {
            ini = new KeyFile ();
            ini.set_list_separator (',');
            ini.load_from_file (filename, KeyFileFlags.NONE);
        } catch (GLib.Error e) {
            throw e;
        }
    }

    private void load_json_file (string filename) {
        if (json != null) {
            json = null;
        }

        var parser = new Json.Parser ();
        try {
            parser.load_from_file (filename);
        } catch (GLib.Error e) {
            throw e;
        }

        json = parser.get_root ();
    }

    private void load_xml_file (string filename) {
        if (xml != null) {
            xml = null;
        }

        Xml.Doc *doc = Xml.Parser.parse_file (filename);
        Xml.XPath.Context *ctx = new Xml.XPath.Context (doc);
        ctx->register_ns ("dcs", "urn:libdcs");
        xml = doc->get_root_element ();
    }

    public override void dump (GLib.FileStream stream) {
        switch (format) {
            case Dcs.ConfigFormat.INI:
                var str = ini.to_data ();
                stream.write (str.data);
                break;
            case Dcs.ConfigFormat.JSON:
                if (Json.MAJOR_VERSION == 1 && Json.MINOR_VERSION >= 2) {
                    var str = Json.to_string (json, true);
                    stream.write (str.data);
                    stream.write ({ 10, 13 });
                } else {
                    stream.puts ("Version of json-glib is too old.\n");
                }
                break;
            case Dcs.ConfigFormat.XML:
                string str;
                Xml.Doc *doc = new Xml.Doc ();
                doc->set_root_element (xml);
                doc->dump (stream);
                break;
            default:
                break;
        }
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
                var json_obj = json.get_object ();
                var dcs = json_obj.get_member (ns);
                var obj = dcs.get_object ();
                var prop = obj.get_member ("properties");
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

        if (val == null) {
            throw new Dcs.ConfigError.NO_VALUE_SET ("No value available");
        }

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
                var json_obj = json.get_object ();
                var dcs = json_obj.get_member (ns);
                var obj = dcs.get_object ();
                var prop = obj.get_member ("properties");
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

        if (val == null) {
            throw new Dcs.ConfigError.NO_VALUE_SET ("No value available");
        }

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
                var json_obj = json.get_object ();
                var dcs = json_obj.get_member (ns);
                var obj = dcs.get_object ();
                var prop = obj.get_member ("properties");
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
                            unavailable = false;
                        }
                    }
                }
                break;
            default:
                throw new Dcs.ConfigError.INVALID_FORMAT ("Invalid format provided");
        }

        if (unavailable) {
            throw new Dcs.ConfigError.NO_VALUE_SET ("No value available");
        }

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
                var json_obj = json.get_object ();
                var dcs = json_obj.get_member (ns);
                var obj = dcs.get_object ();
                var prop = obj.get_member ("properties");
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

        if (val == null) {
            throw new Dcs.ConfigError.NO_VALUE_SET ("No value available");
        }

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
                var json_obj = json.get_object ();
                var dcs = json_obj.get_member (ns);
                var obj = dcs.get_object ();
                var prop = obj.get_member ("properties");
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
                            unavailable = false;
                        }
                    }
                }
                break;
            default:
                throw new Dcs.ConfigError.INVALID_FORMAT ("Invalid format provided");
        }

        if (unavailable) {
            throw new Dcs.ConfigError.NO_VALUE_SET ("No value available");
        }

        return val;
    }


    public override double get_double (string ns,
                                       string key) throws GLib.Error {
        double val = 0.0;
        bool unavailable = true;

        switch (format) {
            case Dcs.ConfigFormat.INI:
                try {
                    val = ini.get_double (ns, key);
                    unavailable = false;
                    break;
                } catch (GLib.Error e) { }
                break;
            case Dcs.ConfigFormat.JSON:
                var json_obj = json.get_object ();
                var dcs = json_obj.get_member (ns);
                var obj = dcs.get_object ();
                var prop = obj.get_member ("properties");
                var prop_obj = prop.get_object ();
                var bprop = prop_obj.get_member (key);
                var type = bprop.get_value_type ();
                if (type.is_a (typeof (double))) {
                    val = prop_obj.get_double_member (key);
                    unavailable = false;
                }
                break;
            case Dcs.ConfigFormat.XML:
                for (Xml.Node *iter = xml->children; iter != null; iter = iter->next) {
                    if (iter->name == "property") {
                        if (iter->get_prop ("name") == key) {
                            val = double.parse (iter->get_content ());
                            unavailable = false;
                        }
                    }
                }
                break;
            default:
                throw new Dcs.ConfigError.INVALID_FORMAT ("Invalid format provided");
        }

        if (unavailable) {
            throw new Dcs.ConfigError.NO_VALUE_SET ("No value available");
        }

        return val;
    }

    public override void set_string (string ns,
                                     string key,
                                     string value) throws GLib.Error {
        switch (format) {
            case Dcs.ConfigFormat.INI:
                try {
                    ini.set_string (ns, key, value);
                } catch (GLib.Error e) {
                    throw new Dcs.ConfigError.NO_VALUE_SET ("No value was set");
                }
                break;
            case Dcs.ConfigFormat.JSON:
                var json_obj = json.get_object ();
                var dcs = json_obj.get_member (ns);
                var obj = dcs.get_object ();
                var prop = obj.get_member ("properties");
                var prop_obj = prop.get_object ();
                prop_obj.set_string_member (key, value);
                break;
            case Dcs.ConfigFormat.XML:
                for (Xml.Node *iter = xml->children; iter != null; iter = iter->next) {
                    if (iter->name == "property") {
                        if (iter->get_prop ("name") == key) {
                            iter->set_content (value);
                        }
                    }
                }
                break;
            default:
                throw new Dcs.ConfigError.INVALID_FORMAT ("Invalid format provided");
        }
    }

    public override void set_int (string ns,
                                  string key,
                                  int value) throws GLib.Error {
        switch (format) {
            case Dcs.ConfigFormat.INI:
                try {
                    ini.set_integer (ns, key, value);
                } catch (GLib.Error e) {
                    throw new Dcs.ConfigError.NO_VALUE_SET ("No value was set");
                }
                break;
            case Dcs.ConfigFormat.JSON:
                var json_obj = json.get_object ();
                var dcs = json_obj.get_member (ns);
                var obj = dcs.get_object ();
                var prop = obj.get_member ("properties");
                var prop_obj = prop.get_object ();
                prop_obj.set_int_member (key, (int64) value);
                break;
            case Dcs.ConfigFormat.XML:
                for (Xml.Node *iter = xml->children; iter != null; iter = iter->next) {
                    if (iter->name == "property") {
                        if (iter->get_prop ("name") == key) {
                            iter->set_content (value.to_string ());
                        }
                    }
                }
                break;
            default:
                throw new Dcs.ConfigError.INVALID_FORMAT ("Invalid format provided");
        }
    }

    public override void set_bool (string ns,
                                   string key,
                                   bool value) throws GLib.Error {
        switch (format) {
            case Dcs.ConfigFormat.INI:
                try {
                    ini.set_boolean (ns, key, value);
                } catch (GLib.Error e) {
                    throw new Dcs.ConfigError.NO_VALUE_SET ("No value was set");
                }
                break;
            case Dcs.ConfigFormat.JSON:
                var json_obj = json.get_object ();
                var dcs = json_obj.get_member (ns);
                var obj = dcs.get_object ();
                var prop = obj.get_member ("properties");
                var prop_obj = prop.get_object ();
                prop_obj.set_boolean_member (key, value);
                break;
            case Dcs.ConfigFormat.XML:
                for (Xml.Node *iter = xml->children; iter != null; iter = iter->next) {
                    if (iter->name == "property") {
                        if (iter->get_prop ("name") == key) {
                            iter->set_content (value.to_string ());
                        }
                    }
                }
                break;
            default:
                throw new Dcs.ConfigError.INVALID_FORMAT ("Invalid format provided");
        }
    }

    public override void set_double (string ns,
                                     string key,
                                     double value) throws GLib.Error {
        switch (format) {
            case Dcs.ConfigFormat.INI:
                try {
                    ini.set_double (ns, key, value);
                } catch (GLib.Error e) {
                    throw new Dcs.ConfigError.NO_VALUE_SET ("No value was set");
                }
                break;
            case Dcs.ConfigFormat.JSON:
                var json_obj = json.get_object ();
                var dcs = json_obj.get_member (ns);
                var obj = dcs.get_object ();
                var prop = obj.get_member ("properties");
                var prop_obj = prop.get_object ();
                prop_obj.set_double_member (key, value);
                break;
            case Dcs.ConfigFormat.XML:
                for (Xml.Node *iter = xml->children; iter != null; iter = iter->next) {
                    if (iter->name == "property") {
                        if (iter->get_prop ("name") == key) {
                            iter->set_content (value.to_string ());
                        }
                    }
                }
                break;
            default:
                throw new Dcs.ConfigError.INVALID_FORMAT ("Invalid format provided");
        }
    }
}
