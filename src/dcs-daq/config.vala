public class Dcs.DAQ.Config : Dcs.AbstractConfig {

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
    public void load_data (string data) throws GLib.Error {
        /* Test if the data is JSON by attempting to load it */
        try {
            var parser = new Json.Parser ();
            parser.load_from_data (data);
            format = Dcs.ConfigFormat.JSON;
        } catch (GLib.Error e) {
            format = Dcs.ConfigFormat.INVALID;
        }

        /* Test if the data is XML by attempting to load it */
        if (this.format != Dcs.ConfigFormat.JSON) {
            Xml.Doc* doc = Xml.Parser.parse_memory (data, data.length);
            if (doc != null) {
                format = Dcs.ConfigFormat.XML;
            } else {
                format = Dcs.ConfigFormat.INVALID;
            }
        }

        try {
            switch (format) {
                case Dcs.ConfigFormat.JSON:
                    if (json != null) {
                        json = null;
                    }
                    json = Dcs.ConfigJson.load_data (data);
                    var nodes = Dcs.ConfigJson.get_child_nodes (json);
                    foreach (var node in nodes) {
                        children.add (new Dcs.ConfigNode.from_json (node));
                    }
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
    public void load_file (string filename) throws GLib.Error {
        /* Test if the data is JSON by attempting to load it */
        try {
            var parser = new Json.Parser ();
            parser.load_from_file (filename);
            format = Dcs.ConfigFormat.JSON;
        } catch (GLib.Error e) {
            format = Dcs.ConfigFormat.INVALID;
        }

        /* Test if the data is XML by attempting to load it */
        if (this.format != Dcs.ConfigFormat.JSON) {
            Xml.Doc* doc = Xml.Parser.parse_file (filename);
            if (doc != null) {
                format = Dcs.ConfigFormat.XML;
            } else {
                format = Dcs.ConfigFormat.INVALID;
            }
        }

        try {
            switch (format) {
                case Dcs.ConfigFormat.JSON:
                    if (json != null) {
                        json = null;
                    }
                    json = Dcs.ConfigJson.load_file (filename);
                    var nodes = Dcs.ConfigJson.get_child_nodes (json);
                    foreach (var node in nodes) {
                        children.add (new Dcs.ConfigNode.from_json (node));
                    }
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
            try {
                foreach (var child in children) {
                    child.set_format (format);
                }
                this.format = format;
            } catch (GLib.Error e) {
                critical (e.message);
            }
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

        debug ("fuck");

        switch (format) {
            case Dcs.ConfigFormat.JSON:
                debug ("tard");
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
