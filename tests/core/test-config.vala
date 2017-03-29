/**
 * Mock object to instantiate an abstract class for testing.
 */
public class Dcs.Test.Config : Dcs.AbstractConfig {

    private KeyFile ini;

    private Json.Node json;

    private Xml.Node *xml;

    construct {
        children = new Gee.ArrayList<Dcs.ConfigNode> (
            (Gee.EqualDataFunc<Dcs.ConfigNode>) Dcs.ConfigNode.equals);
    }

    /**
     * XXX In a class that actually implements this functionality this should
     *     be a constructor with a .from_data (...).
     */
    public void load_data (string data, Dcs.ConfigFormat format)
                           throws GLib.Error {
        this.format = format;

        try {
            switch (format) {
                case Dcs.ConfigFormat.INI:
                    if (ini != null) {
                        ini = null;
                    }
                    ini = new KeyFile ();
                    ini.set_list_separator (',');
                    ini.load_from_data (data, -1, KeyFileFlags.NONE);
                    break;
                case Dcs.ConfigFormat.JSON:
                    if (json != null) {
                        json = null;
                    }
                    json = Dcs.ConfigJson.load_data (data);
                    var nodes = Dcs.ConfigJson.get_child_nodes (json);
                    foreach (var node in nodes) {
                        children.add (new Dcs.ConfigNode.from_json (node));
                    }
                    assert (has_children ());
                    break;
                case Dcs.ConfigFormat.XML:
                    if (xml != null) {
                        xml = null;
                    }
                    xml = Dcs.ConfigXml.load_data (data, "dcs");
                    var nodes = Dcs.ConfigXml.get_child_nodes (xml);
                    foreach (var node in nodes) {
                        children.add (new Dcs.ConfigNode.from_xml (node));
                    }
                    assert (has_children ());
                    break;
                default:
                    throw new Dcs.ConfigError.INVALID_FORMAT (
                        "Invalid format provided");
            }
        } catch (GLib.Error e) {
            throw e;
        }
    }

    /**
     * XXX In a class that actually implements this functionality this should
     *     be a constructor with a .from_file (...).
     */
    public void load_file (string filename, Dcs.ConfigFormat format)
                           throws GLib.Error {
        this.format = format;

        try {
            switch (format) {
                case Dcs.ConfigFormat.INI:
                    if (ini != null) {
                        ini = null;
                    }
                    ini = new KeyFile ();
                    ini.set_list_separator (',');
                    ini.load_from_file (filename, KeyFileFlags.NONE);
                    break;
                case Dcs.ConfigFormat.JSON:
                    if (json != null) {
                        json = null;
                    }
                    json = Dcs.ConfigJson.load_file (filename);
                    var nodes = Dcs.ConfigJson.get_child_nodes (json);
                    foreach (var node in nodes) {
                        children.add (new Dcs.ConfigNode.from_json (node));
                    }
                    assert (has_children ());
                    break;
                case Dcs.ConfigFormat.XML:
                    if (xml != null) {
                        xml = null;
                    }
                    xml = Dcs.ConfigXml.load_file (filename, "dcs");
                    var nodes = Dcs.ConfigXml.get_child_nodes (xml);
                    foreach (var node in nodes) {
                        children.add (new Dcs.ConfigNode.from_xml (node));
                    }
                    assert (has_children ());
                    break;
                default:
                    throw new Dcs.ConfigError.INVALID_FORMAT (
                        "Invalid format provided");
            }
        } catch (GLib.Error e) {
            throw e;
        }
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
                val = Dcs.ConfigJson.get_string (json, key);
                break;
            case Dcs.ConfigFormat.XML:
                val = Dcs.ConfigXml.get_string (xml, key);
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
                val = Dcs.ConfigJson.get_string_list (json, key);
                break;
            case Dcs.ConfigFormat.XML:
                val = Dcs.ConfigXml.get_string_list (xml, key);
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
                } catch (GLib.Error e) { }
                break;
            case Dcs.ConfigFormat.JSON:
                try {
                    val = Dcs.ConfigJson.get_int (json, key);
                    unavailable = false;
                } catch (GLib.Error e) {
                    if (e is Dcs.ConfigError) {
                        throw e;
                    }
                }
                break;
            case Dcs.ConfigFormat.XML:
                try {
                    val = Dcs.ConfigXml.get_int (xml, key);
                    unavailable = false;
                } catch (GLib.Error e) {
                    if (e is Dcs.ConfigError) {
                        throw e;
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
                val = Dcs.ConfigJson.get_int_list (json, key);
                break;
            case Dcs.ConfigFormat.XML:
                val = Dcs.ConfigXml.get_int_list (xml, key);
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
                } catch (GLib.Error e) { }
                break;
            case Dcs.ConfigFormat.JSON:
                try {
                    val = Dcs.ConfigJson.get_bool (json, key);
                    unavailable = false;
                } catch (GLib.Error e) {
                    if (e is Dcs.ConfigError) {
                        throw e;
                    }
                }
                break;
            case Dcs.ConfigFormat.XML:
                try {
                    val = Dcs.ConfigXml.get_bool (xml, key);
                    unavailable = false;
                } catch (GLib.Error e) {
                    if (e is Dcs.ConfigError) {
                        throw e;
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
                } catch (GLib.Error e) { }
                break;
            case Dcs.ConfigFormat.JSON:
                try {
                    val = Dcs.ConfigJson.get_double (json, key);
                    unavailable = false;
                } catch (GLib.Error e) {
                    if (e is Dcs.ConfigError) {
                        throw e;
                    }
                }
                break;
            case Dcs.ConfigFormat.XML:
                try {
                    val = Dcs.ConfigXml.get_double (xml, key);
                    unavailable = false;
                } catch (GLib.Error e) {
                    if (e is Dcs.ConfigError) {
                        throw e;
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
                Dcs.ConfigJson.set_string (json, key, value);
                break;
            case Dcs.ConfigFormat.XML:
                Dcs.ConfigXml.set_string (xml, key, value);
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
                Dcs.ConfigJson.set_int (json, key, value);
                break;
            case Dcs.ConfigFormat.XML:
                Dcs.ConfigXml.set_int (xml, key, value);
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
                Dcs.ConfigJson.set_bool (json, key, value);
                break;
            case Dcs.ConfigFormat.XML:
                Dcs.ConfigXml.set_bool (xml, key, value);
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
                Dcs.ConfigJson.set_double (json, key, value);
                break;
            case Dcs.ConfigFormat.XML:
                Dcs.ConfigXml.set_double (xml, key, value);
                break;
            default:
                throw new Dcs.ConfigError.INVALID_FORMAT ("Invalid format provided");
        }
    }
}
