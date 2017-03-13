/**
 * Configuration node to use as part of the objects data in a tree.
 */
public class Dcs.ConfigNode : Dcs.AbstractConfig {

    private string @namespace = "dcs";

    private Dcs.ConfigFormat format;

    private Json.Node json;

    private Xml.Node *xml;

    private Gee.ArrayList<Dcs.ConfigNode> children;

    /**
     * Parent node in the tree.
     */
    public Dcs.ConfigNode parent { get; internal set; default = null; }

    /**
     * Type of object data held by this node.
     */
    public string obj_type { get; private set; }

    /**
     * Default constructor.
     */
    public ConfigNode (string obj_type, Dcs.ConfigFormat format) {
        this.obj_type = obj_type;
        this.format = format;
    }

    /**
     * Construct using an XML node.
     */
    public ConfigNode.from_xml (Xml.Node* node) {
        format = Dcs.ConfigFormat.XML;
        xml = node;
    }

    /**
     * Construct using a JSON object.
     */
    public ConfigNode.from_json (Json.Node node) {
        format = Dcs.ConfigFormat.JSON;
        json = node;
    }

    /**
     * {@inheritDoc}
     */
    public override string get_namespace () throws GLib.Error {
        return @namespace;
    }

    /**
     * {@inheritDoc}
     */
    public override Dcs.ConfigFormat get_format () throws GLib.Error {
        return format;
    }

    /**
     * {@inheritDoc}
     */
    public override string get_string (string ns,
                                       string key) throws GLib.Error {
        string val = null;

        switch (format) {
            case Dcs.ConfigFormat.JSON:
                val = Dcs.AbstractConfig.json_get_string (json, key);
                break;
            case Dcs.ConfigFormat.XML:
                val = Dcs.AbstractConfig.xml_get_string (xml, key);
                break;
            default:
                throw new Dcs.ConfigError.INVALID_FORMAT (
                    "The node data is in an invalid format");
        }

        if (val == null) {
            throw new Dcs.ConfigError.NO_VALUE_FOUND (
                "No property was found with key " + key);
        }

        return val;
    }

    /**
     * {@inheritDoc}
     */
    public override Gee.ArrayList<string> get_string_list (string ns,
                                                           string key)
                                                           throws GLib.Error {
        Gee.ArrayList<string> val = null;

        switch (format) {
            case Dcs.ConfigFormat.JSON:
                val = Dcs.AbstractConfig.json_get_string_list (json, key);
                break;
            case Dcs.ConfigFormat.XML:
                val = Dcs.AbstractConfig.xml_get_string_list (xml, key);
                break;
            default:
                throw new Dcs.ConfigError.INVALID_FORMAT (
                    "The node data is in an invalid format");
        }

        if (val == null) {
            throw new Dcs.ConfigError.NO_VALUE_SET (
                "No property was found with key " + key);
        }

        return val;
    }

    /**
     * {@inheritDoc}
     */
    public override int get_int (string ns,
                                 string key)
                                 throws GLib.Error {
        int val = 0;
        bool unavailable = true;

        switch (format) {
            case Dcs.ConfigFormat.JSON:
                try {
                    val = Dcs.AbstractConfig.json_get_int (json, key);
                    unavailable = false;
                } catch (GLib.Error e) {
                    if (e is Dcs.ConfigError) {
                        throw e;
                    }
                }
                break;
            case Dcs.ConfigFormat.XML:
                try {
                    val = Dcs.AbstractConfig.xml_get_int (xml, key);
                    unavailable = false;
                } catch (GLib.Error e) {
                    if (e is Dcs.ConfigError) {
                        throw e;
                    }
                }
                break;
            default:
                throw new Dcs.ConfigError.INVALID_FORMAT (
                    "The node data is in an invalid format");
        }

        if (unavailable) {
            throw new Dcs.ConfigError.NO_VALUE_SET (
                "No property was found with key " + key);
        }

        return val;
    }

    /**
     * {@inheritDoc}
     */
    public override Gee.ArrayList<int> get_int_list (string ns,
                                                     string key)
                                                     throws GLib.Error {
        Gee.ArrayList<int> val = null;

        switch (format) {
            case Dcs.ConfigFormat.JSON:
                val = Dcs.AbstractConfig.json_get_int_list (json, key);
                break;
            case Dcs.ConfigFormat.XML:
                val = Dcs.AbstractConfig.xml_get_int_list (xml, key);
                break;
            default:
                throw new Dcs.ConfigError.INVALID_FORMAT (
                    "The node data is in an invalid format");
        }

        if (val == null) {
            throw new Dcs.ConfigError.NO_VALUE_SET (
                "No property was found with key " + key);
        }

        return val;
    }

    /**
     * {@inheritDoc}
     */
    public override bool get_bool (string ns,
                                   string key)
                                   throws GLib.Error {
        bool val = false;
        bool unavailable = true;

        switch (format) {
            case Dcs.ConfigFormat.JSON:
                val = Dcs.AbstractConfig.json_get_bool (json, key);
                unavailable = false;
                break;
            case Dcs.ConfigFormat.XML:
                val = Dcs.AbstractConfig.xml_get_bool (xml, key);
                unavailable = false;
                break;
            default:
                throw new Dcs.ConfigError.INVALID_FORMAT (
                    "The node data is in an invalid format");
        }

        if (unavailable) {
            throw new Dcs.ConfigError.NO_VALUE_SET (
                "No property was found with key " + key);
        }

        return val;
    }

    /**
     * {@inheritDoc}
     */
    public override double get_double (string ns,
                                       string key) throws GLib.Error {
        double val = 0.0;
        bool unavailable = true;

        switch (format) {
            case Dcs.ConfigFormat.JSON:
                val = Dcs.AbstractConfig.json_get_double (json, key);
                unavailable = false;
                break;
            case Dcs.ConfigFormat.XML:
                val = Dcs.AbstractConfig.xml_get_double (xml, key);
                unavailable = false;
                break;
            default:
                throw new Dcs.ConfigError.INVALID_FORMAT (
                    "The node data is in an invalid format");
        }

        if (unavailable) {
            throw new Dcs.ConfigError.NO_VALUE_SET (
                "No property was found with key " + key);
        }

        return val;
    }

    /**
     * {@inheritDoc}
     */
    public override void set_string (string ns,
                                     string key,
                                     string value) throws GLib.Error {
        switch (format) {
            case Dcs.ConfigFormat.JSON:
                Dcs.AbstractConfig.json_set_string (json, key, value);
                break;
            case Dcs.ConfigFormat.XML:
                Dcs.AbstractConfig.xml_set_string (xml, key, value);
                break;
            default:
                throw new Dcs.ConfigError.INVALID_FORMAT (
                    "The node data is in an invalid format");
        }
    }

    /**
     * {@inheritDoc}
     */
    public override void set_int (string ns,
                                  string key,
                                  int value) throws GLib.Error {
        switch (format) {
            case Dcs.ConfigFormat.JSON:
                Dcs.AbstractConfig.json_set_int (json, key, value);
                break;
            case Dcs.ConfigFormat.XML:
                Dcs.AbstractConfig.xml_set_int (xml, key, value);
                break;
            default:
                throw new Dcs.ConfigError.INVALID_FORMAT (
                    "The node data is in an invalid format");
        }
    }

    /**
     * {@inheritDoc}
     */
    public override void set_bool (string ns,
                                   string key,
                                   bool value) throws GLib.Error {
        switch (format) {
            case Dcs.ConfigFormat.JSON:
                Dcs.AbstractConfig.json_set_bool (json, key, value);
                break;
            case Dcs.ConfigFormat.XML:
                Dcs.AbstractConfig.xml_set_bool (xml, key, value);
                break;
            default:
                throw new Dcs.ConfigError.INVALID_FORMAT (
                    "The node data is in an invalid format");
        }
    }

    /**
     * {@inheritDoc}
     */
    public override void set_double (string ns,
                                     string key,
                                     double value) throws GLib.Error {
        switch (format) {
            case Dcs.ConfigFormat.JSON:
                Dcs.AbstractConfig.json_set_double (json, key, value);
                break;
            case Dcs.ConfigFormat.XML:
                Dcs.AbstractConfig.xml_set_double (xml, key, value);
                break;
            default:
                throw new Dcs.ConfigError.INVALID_FORMAT (
                    "The node data is in an invalid format");
        }
    }
}
