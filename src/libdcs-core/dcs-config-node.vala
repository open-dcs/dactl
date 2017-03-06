public class Dcs.ConfigNode : GLib.Object, Dcs.Config {

    private Dcs.ConfigFormat format;

    public Dcs.ConfigNode parent { get; private set; default = null; }

    private Gee.ArrayList<Dcs.ConfigNode> children;

/*
 *    public Gee.ArrayList<GLib.Variant> properties;
 *
 *    public string type { get; private set; }
 */

    /**
     * Default constructor.
     */
    public ConfigNode () {
        format = Dcs.ConfigFormat.XML;
    }

    /**
     * Construct using an XML node.
     */
    public ConfigNode.from_xml (Xml.Node* node) {
        format = Dcs.ConfigFormat.XML;
    }

    /**
     * Construct using a JSON object.
     */
    public ConfigNode.from_json (Json.Node node) {
        format = Dcs.ConfigFormat.JSON;
    }

    /**
     * Construct using INI group from a KeyFile.
     */
    public ConfigNode.from_ini (string group) {
        format = Dcs.ConfigFormat.INI;
    }

    /**
     * {@inheritDoc}
     */
    public string get_namespace () throws GLib.Error {
        return "//dcs//";
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
    public string get_string (string ns, string key) throws GLib.Error {
        string? value = null;
        switch (format) {
            case Dcs.ConfigFormat.XML:
                break;
            case Dcs.ConfigFormat.JSON:
                break;
            case Dcs.ConfigFormat.INI:
                break;
            default:
                throw new Dcs.ConfigError.INVALID_FORMAT (
                    "The node data is in an invalid format");
        }

        if (value == null) {
            throw new Dcs.ConfigError.NO_VALUE_FOUND (
                "No property was found with key " + key);
        }

        return value;
    }

    /**
     * {@inheritDoc}
     */
    public Gee.ArrayList<string> get_string_list (string ns,
                                                  string key)
                                                  throws GLib.Error {
        return null;
    }

    /**
     * {@inheritDoc}
     */
    public int get_int (string ns,
                        string key)
                        throws GLib.Error {
        return -1;
    }

    /**
     * {@inheritDoc}
     */
    public Gee.ArrayList<int> get_int_list (string ns,
                                            string key)
                                            throws GLib.Error {
        return null;
    }

    /**
     * {@inheritDoc}
     */
    public bool get_bool (string ns,
                          string key)
                          throws GLib.Error {
        return false;
    }

    /**
     * {@inheritDoc}
     */
    public double get_double (string ns,
                              string key) throws GLib.Error {
        return -1.0;
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
