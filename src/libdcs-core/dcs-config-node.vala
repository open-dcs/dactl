/**
 * Configuration node to use as part of the objects data in a tree.
 */
public class Dcs.ConfigNode : Dcs.AbstractConfig {

    private string @namespace = "dcs";

    private Dcs.ConfigFormat format;

    private Json.Node json { internal get; private set; }

    private Xml.Node *xml { internal get; private set; }

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
     *
     * Configuration node data defined using XML must be in the form:
     *
     * {{{
     * <object id="foo" type="foo-object">
     *   <property name="foo-prop-a">1</property>
     *   <property name="foo-prop-b">1.0</property>
     *   <property name="foo-prop-c">true</property>
     *   <property name="foo-prop-d">string</property>
     *   <reference path="/path/to/ref"/>
     *   <object id="bar" type="bar-object">
     *     <!-- and so on -->
     *   </object>
     * </object>
     * }}}
     */
    public ConfigNode.from_xml (Xml.Node* node) {
        format = Dcs.ConfigFormat.XML;
        xml = node;

        @namespace = node->get_prop ("id");
        obj_type = node->get_prop ("type");

        for (Xml.Node *iter = node->children; iter != null; iter = iter->next) {
            if (iter->name == "property") {
                var value = iter->get_content ();
                var key = iter->get_prop ("name");
                var int_regex = new Regex ("^[-+]?[0-9]+$",
                                           RegexCompileFlags.CASELESS);
                var double_regex = new Regex ("^[-+]?[0-9]*\\.?[0-9]+$",
                                              RegexCompileFlags.CASELESS);
                var bool_regex = new Regex ("^(true|false)$",
                                            RegexCompileFlags.CASELESS);

                if (int_regex.match (value)) {
                    properties.@set (key, new Variant.int64 (int64.parse (value)));
                } else if (double_regex.match (value)) {
                    properties.@set (key, new Variant.double (double.parse (value)));
                } else if (bool_regex.match (value)) {
                    properties.@set (key, new Variant.boolean (bool.parse (value)));
                } else {
                    /* If it isn`t an int, double, or boolean it`s a string */
                    properties.@set (key, new Variant.string (value));
                }
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
     *
     * Configuration node data defined using JSON must be in the form:
     *
     * {{{
     * {
     *   "foo0": {
     *     "type": "foo-node",
     *     "properties": {
     *       "val-a": 1,
     *       "val-b": "one",
     *       "val-c": true,
     *       "val-d": 1.0
     *     },
     *     "references": [
     *       "/foo1", "/foo2"
     *     ],
     *     "objects": {
     *       "bar0": {
     *         "type": "bar-node",
     *         "properties": {
     *           "val-a": 2,
     *           "val-b": "two",
     *           "val-c": false
     *         },
     *         "references": [
     *           "../bar1"
     *         ]
     *       },
     *       "bar1": {
     *         "type": "bar-node",
     *         "properties": {
     *           "val-a": 2,
     *           "val-b": "two",
     *           "val-c": false
     *         },
     *         "references": [
     *           "../bar0"
     *         ]
     *       }
     *     }
     *   }
     * }
     * }}}
     */
    public ConfigNode.from_json (Json.Node node) {
        format = Dcs.ConfigFormat.JSON;
        json = node;

        var obj = node.get_object ();
        @namespace = obj.get_members ().nth_data (0);
        var data = obj.get_object_member (@namespace);
        obj_type = data.get_string_member ("type");

        if (data.has_member ("properties")) {
            var props = data.get_object_member ("properties");
            foreach (var name in props.get_members ()) {
                var member = props.get_member (name);
                var type = member.get_value_type ();
                if (type.is_a (typeof (string))) {
                    properties.@set (name, new Variant.string (member.get_string ()));
                } else if (type.is_a (typeof (int64))) {
                    properties.@set (name, new Variant.int64 (member.get_int ()));
                } else if (type.is_a (typeof (bool))) {
                    properties.@set (name, new Variant.boolean (member.get_boolean ()));
                } else if (type.is_a (typeof (double))) {
                    properties.@set (name, new Variant.double (member.get_double ()));
                }
            }
        }

        if (data.has_member ("references")) {
            var refs = data.get_array_member ("references").get_elements ();
            foreach (var @ref in refs) {
                references.add (@ref.get_string ());
            }
        }

        if (data.has_member ("objects")) {
            var objs = data.get_object_member ("objects");
            foreach (var name in objs.get_members ()) {
                var builder = new Json.Builder ();
                builder.begin_object ();
                builder.set_member_name (name);
                builder.add_value (objs.get_member (name));
                builder.end_object ();

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
        foreach (var key in properties.keys) {
            var value = "";
            var prop = properties.@get (key);
            if (prop.is_of_type (VariantType.STRING)) {
                value = "%s".printf (prop.get_string ());
            } else if (prop.is_of_type (VariantType.INT64)) {
                value = "%d".printf ((int) prop.get_int64 ());
            } else if (prop.is_of_type (VariantType.BOOLEAN)) {
                value = "%s".printf (prop.get_boolean ().to_string ());
            } else if (prop.is_of_type (VariantType.DOUBLE)) {
                value = "%f".printf (prop.get_double ());
            }
            val += "  • %s\t%s\n".printf (key, value);
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

    public void print_json () {
        stdout.printf (Json.to_string (json, true));
    }

    public void print_xml () {
        var doc = new Xml.Doc ();
        doc.set_root_element (xml);
        doc.dump (stdout);
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
                // create new node
                // if properties found in current node
                //   create properties object
                //   foreach property in current node properties
                //     add property to properties
                // if object(s) found in current node
                //   foreach object in objects
                //     add object
                var builder = new Json.Builder ();

                builder.begin_object ();
                builder.set_member_name (@namespace);
                builder.begin_object ();
                builder.set_member_name ("type");
                builder.add_string_value (obj_type);

                /* Add the properties object */
                if (properties.size > 0) {
                    builder.set_member_name ("properties");
                    builder.begin_object ();
                    foreach (var key in properties.keys) {
                        var prop = properties.@get (key);
                        builder.set_member_name (key);
                        if (prop.is_of_type (VariantType.STRING)) {
                            builder.add_string_value (prop.get_string ());
                        } else if (prop.is_of_type (VariantType.INT64)) {
                            builder.add_int_value (prop.get_int64 ());
                        } else if (prop.is_of_type (VariantType.BOOLEAN)) {
                            builder.add_boolean_value (prop.get_boolean ());
                        } else if (prop.is_of_type (VariantType.DOUBLE)) {
                            builder.add_double_value (prop.get_double ());
                        }
                    }
                    builder.end_object ();
                }

                /* Add the references list */
                if (references.size > 0) {
                    builder.set_member_name ("references");
                    builder.begin_array ();
                    foreach (var @ref in references) {
                        builder.add_string_value (@ref);
                    }
                    builder.end_array ();
                }

                /* Add the objects object */
                if (children.size > 0) {
                    builder.set_member_name ("objects");
                    builder.begin_object ();
                    foreach (var child in children) {
                        child.set_format (format);
                        builder.set_member_name (child.get_namespace ());
                        var obj = child.json.get_object ();
                        builder.add_value (obj.get_member (child.get_namespace ()));
                    }
                    builder.end_object ();
                }

                builder.end_object ();
                builder.end_object ();

                if (json != null) {
                    json = null;
                }
                json = builder.get_root ();
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
                var doc = new Xml.Doc ();

                var obj = doc.new_node (null, "object", null);
                obj->new_prop ("id", @namespace);
                obj->new_prop ("type", obj_type);

                /* Add the properties object */
                if (properties.size > 0) {
                    foreach (var key in properties.keys) {
                        var node = doc.new_node (null, "property", null);
                        node->new_prop ("name", key);
                        var value = "";
                        var prop = properties.@get (key);
                        if (prop.is_of_type (VariantType.STRING)) {
                            value = prop.get_string ();
                        } else if (prop.is_of_type (VariantType.INT64)) {
                            value = prop.get_int64 ().to_string ();
                        } else if (prop.is_of_type (VariantType.BOOLEAN)) {
                            value = prop.get_boolean ().to_string ();
                        } else if (prop.is_of_type (VariantType.DOUBLE)) {
                            value = prop.get_double ().to_string ();
                        }
                        node->set_content (value);
                        obj->add_child (node);
                    }
                }

                /* Add the references list */
                if (references.size > 0) {
                    foreach (var @ref in references) {
                        var node = doc.new_node (null, "reference", null);
                        node->new_prop ("path", @ref);
                        obj->add_child (node);
                    }
                }

                /* Add the objects object */
                if (children.size > 0) {
                    foreach (var child in children) {
                        child.set_format (format);
                        //var node = doc.new_node (null, "object", null);
                        obj->add_child (child.xml);
                    }
                }

                //doc.set_root_element (obj);

                if (xml != null) {
                    xml = null;
                }
                //xml = doc.get_root_element ();
                xml = obj;
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
