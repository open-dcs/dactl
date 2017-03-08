/**
 * Configuration node to use as part of the objects data in a tree.
 */
public class Dcs.ConfigNode : Dcs.Config, GLib.Object {

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
    public string get_namespace () throws GLib.Error {
        return @namespace;
    }

    /**
     * {@inheritDoc}
     */
    public Dcs.ConfigFormat get_format () throws GLib.Error {
        return format;
    }

    /**
     * {@inheritDoc}
     */
    public string get_string (string ns,
                              string key) throws GLib.Error {
        string val = null;

        switch (format) {
            case Dcs.ConfigFormat.JSON:
                val = Dcs.Config.json_get_string (json, key);
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
    public Gee.ArrayList<string> get_string_list (string ns,
                                                  string key)
                                                  throws GLib.Error {
        Gee.ArrayList<string> val = null;

        switch (format) {
            case Dcs.ConfigFormat.JSON:
                val = Dcs.Config.json_get_string_list (json, key);
                break;
            case Dcs.ConfigFormat.XML:
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
    public int get_int (string ns,
                        string key)
                        throws GLib.Error {
        int val = 0;
        bool unavailable = true;

        switch (format) {
            case Dcs.ConfigFormat.JSON:
                try {
                    val = Dcs.Config.json_get_int (json, key);
                    unavailable = false;
                } catch (GLib.Error e) {
                    if (e is Dcs.ConfigError) {
                        throw e;
                    }
                }
                break;
            case Dcs.ConfigFormat.XML:
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
    public Gee.ArrayList<int> get_int_list (string ns,
                                            string key)
                                            throws GLib.Error {
        Gee.ArrayList<int> val = null;

        switch (format) {
            case Dcs.ConfigFormat.JSON:
                break;
            case Dcs.ConfigFormat.XML:
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
    public bool get_bool (string ns,
                          string key)
                          throws GLib.Error {
        bool val = false;
        bool unavailable = true;

        switch (format) {
            case Dcs.ConfigFormat.JSON:
                break;
            case Dcs.ConfigFormat.XML:
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
    public double get_double (string ns,
                              string key) throws GLib.Error {
        double val = 0.0;
        bool unavailable = true;

        switch (format) {
            case Dcs.ConfigFormat.JSON:
                break;
            case Dcs.ConfigFormat.XML:
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
    public void set_string (string ns,
                            string key,
                            string value) throws GLib.Error {
    }

    /**
     * {@inheritDoc}
     */
    public void set_int (string ns,
                         string key,
                         int value) throws GLib.Error {
    }

    /**
     * {@inheritDoc}
     */
    public void set_bool (string ns,
                          string key,
                          bool value) throws GLib.Error {
    }

    /**
     * {@inheritDoc}
     */
    public void set_double (string ns,
                            string key,
                            double value) throws GLib.Error {
    }
}
