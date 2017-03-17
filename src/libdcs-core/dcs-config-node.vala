/**
 * Configuration node to use as part of the objects data in a tree.
 */
public class Dcs.ConfigNode : Dcs.AbstractConfig {

    private string @namespace = "dcs";

    private Dcs.ConfigFormat format;

    private Json.Node json;

    private Xml.Node *xml;

    private Gee.ArrayList<Dcs.ConfigNode> children;

    private Gee.HashMap<string, Variant> properties;

    private Gee.ArrayList<string> references;

    /**
     * Parent node in the tree.
     */
    public Dcs.ConfigNode parent { get; internal set; default = null; }

    /**
     * Type of object data held by this node.
     */
    public string obj_type { get; private set; }

    construct {
        children = new Gee.ArrayList<Dcs.ConfigNode> ();
        properties = new Gee.HashMap<string, Variant> ();
        references = new Gee.ArrayList<string> ();
    }

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

        @namespace = node->get_prop ("id");
        obj_type = node->get_prop ("type");

        for (Xml.Node *iter = node->children; iter != null; iter = iter->next) {
            if (iter->name == "property") {
                properties.@set (iter->get_prop ("name"),
                                 new Variant.string(iter->get_content ()));
            } else if (iter->name == "reference") {
                references.add (iter->get_prop ("path"));
            } else if (iter->name == "object") {
                var child = new ConfigNode.from_xml (iter);
                child.parent = this;
                children.add (child);
            }
        }
    }

    /**
     * Construct using a JSON object.
     */
    public ConfigNode.from_json (Json.Node node) {
        format = Dcs.ConfigFormat.JSON;
        json = node;

        var obj = node.get_object ();
        @namespace = obj.get_members ().nth_data (0);
        var data = obj.get_object_member (@namespace);
        obj_type = data.get_string_member ("type");

        var props = data.get_object_member ("properties");
        /*
         *foreach (var prop in props.get_elements ()) {
         *    properties.@set ();
         *}
         */

        var refs = data.get_array_member ("references").get_elements ();
        foreach (var @ref in refs) {
            references.add (@ref.get_string ());
        }

        if (data.has_member ("objects")) {
            var objs = data.get_object_member ("objects");
            foreach (var name in objs.get_members ()) {
                var builder = new Json.Builder ();
                builder.begin_object ();
                builder.set_member_name (name);
                builder.add_value (objs.get_member (name));
                builder.end_object ();

                stdout.printf ("%s\n", Json.to_string (builder.get_root (), true));

                var child = new ConfigNode.from_json (builder.get_root ());
                child.parent = this;
                children.add (child);
            }
        }
    }

    /**
     * Dump node content to a string.
     */
    public string to_string () {
        string val = "";

        val += "Node (id: %s, type: %s)\n".printf (@namespace, obj_type);
        val += "------------------------------------\n\n";

        val += " Properties:\n\n";
        foreach (var prop in properties.keys) {
            val += "  • %s\t%s\n".printf (prop, properties.@get (prop).get_string ());
        }

        if (references.size > 0) {
            val += "\n References:\n\n";
            foreach (var @ref in references) {
                val += "  • %s\n".printf (@ref);
            }
        }

        if (children.size > 0) {
            val += "\n Children:\n\n";
            foreach (var node in children) {
                val += "  • %s\n".printf (node.get_namespace ());
            }
        }

        return val;
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
     * Setting the format converts the node content from one type to another.
     *
     * @param format The format to convert to.
     *
     * @throws Dcs.ConfigError Configuration error, see {@link Dcs.ConfigError}.
     */
    public void set_format (Dcs.ConfigFormat format) throws GLib.Error {
        if (this.format == format) {
            /* Nothing to do */
            return;
        }

        switch (format) {
            case Dcs.ConfigFormat.JSON:
                debug ("Converting node to JSON -- doesn't work yet");
                // create new node
                // if properties found in current node
                //   create properties object
                //   foreach property in current node properties
                //     add property to properties
                // if object(s) found in current node
                //   foreach object in objects
                //     add object
                break;
            case Dcs.ConfigFormat.XML:
                debug ("Converting node to XML -- doesn't work yet");
                // create new node
                // if properties found in current node
                //   foreach property in current node properties
                //     add property node
                // if object(s) found in current node
                //   foreach object in objects
                //     add object
                break;
            default:
                throw new Dcs.ConfigError.UNSUPPORTED_FORMAT (
                    "Destination format for conversion is not supported");
        }

        config_changed (Dcs.ConfigEntry.FORMAT);
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

    private bool is_valid_path (string path) {
        /*
         * consider stripping prefixes:
         *  dcs:///
         *  dcs://localhost[:port]/
         *  dcs://<hostname([\.\w*])*>[:port]/
         *  dcs://<IP address>[:port]/
         *
         * valid:
         *  obj0
         *  /obj0
         *  /ctr0/obj0
         *
         * not valid:
         *  /
         *  ctr0/obj0
         */

        if (path == null) {
            return false;
        } else if (path == "") {
            return false;
        } else if (path.contains ("/") && (path.get_char (0) != '/')) {
            return false;
        }

        return true;
    }

    /**
     * {@inheritDoc}
     */
    public override Dcs.Config get_node (string ns,
                                         string key) throws GLib.Error {
        Dcs.Config val = null;

        if (!is_valid_path (key)) {
            throw new Dcs.ConfigError.INVALID_PATH (
                "An invalid path was provided");
        }

        if (children != null) {
            foreach (var node in children) {
                /*
                 *if (key == node.get_namespace ()) {
                 *    return node;
                 *}
                 */
            }
        }

        /*
         *if () {
         *    try {
         *    } catch () {
         *    }
         *}
         */

        /*
         *if (val == null) {
         *    throw new Dcs.ConfigError.NO_VALUE_SET (
         *        "No property was found with key " + key);
         *}
         */

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

    /**
     * {@inheritDoc}
     */
    public override void set_node (string ns,
                                   string key,
                                   Dcs.Config? value) throws GLib.Error {
        switch (format) {
        }
    }
}
