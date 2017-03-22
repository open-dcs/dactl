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

    private Type type_check (string value) {
        var regint = new Regex ("^[-+]?[0-9]+$",
                                RegexCompileFlags.CASELESS);
        var regdbl = new Regex ("^[-+]?[0-9]*\\.?[0-9]+$",
                                RegexCompileFlags.CASELESS);
        var regbool = new Regex ("^(true|false)$",
                                 RegexCompileFlags.CASELESS);

        if (regint.match (value)) {
            return typeof (int);
        } else if (regdbl.match (value)) {
            return typeof (double);
        } else if (regbool.match (value)) {
            return typeof (bool);
        } else {
            /* If it isn`t an int, double, or boolean it`s a string */
            return typeof (string);
        }
    }

    /**
     * Construct using an XML node. Currently all array elements for properties
     * must be the same type.
     *
     * Configuration node data defined using XML must be in the form:
     *
     * {{{
     * <object id="foo0" type="foo-node">
     *   <property name="val-a">1</property>
     *   <property name="val-b">string</property>
     *   <property name="val-c">true</property>
     *   <property name="val-d">1.1</property>
     *   <property name="val-e">1, 2</property>
     *   <property name="val-f">one, two</property>
     *   <property name="val-g">true, false</property>
     *   <property name="val-h">1.1, 2.2</property>
     *   <reference path="/foo1"/>
     *   <object id="bar" type="bar-node">
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
                var type = type_check (value);

                if (value.contains (",")) {
                    var list = value.split (",");
                    /* TODO This should complain if multiple types were set */
                    var arr_type = type_check (list[0]);
                    Variant[] arr = {};
                    VariantType val_type = VariantType.STRING;
                    foreach (var item in list) {
                        if (arr_type.is_a (typeof (int))) {
                            arr += new Variant.int64 (int64.parse (item));
                            val_type = VariantType.INT64;
                        } else if (arr_type.is_a (typeof (double))) {
                            arr += new Variant.double (double.parse (item));
                            val_type = VariantType.DOUBLE;
                        } else if (arr_type.is_a (typeof (bool))) {
                            arr += new Variant.boolean (bool.parse (item));
                            val_type = VariantType.BOOLEAN;
                        } else if (arr_type.is_a (typeof (string))) {
                            arr += new Variant.string (item);
                            val_type = VariantType.STRING;
                        }
                    }
                    if (arr.length > 0) {
                        properties.@set (key, new Variant.array (val_type, arr));
                    }
                } else if (type.is_a (typeof (int))) {
                    properties.@set (key, new Variant.int64 (int64.parse (value)));
                } else if (type.is_a (typeof (double))) {
                    properties.@set (key, new Variant.double (double.parse (value)));
                } else if (type.is_a (typeof (bool))) {
                    properties.@set (key, new Variant.boolean (bool.parse (value)));
                } else if (type.is_a (typeof (string))) {
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
     * Construct using a JSON object. Currently all array elements for
     * properties must be the same type.
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
     *       "val-d": 1.1,
     *       "val-e": [1, 2],
     *       "val-f": ["one", "two"],
     *       "val-g": [true, false],
     *       "val-h": [1.1, 2.2],
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
                if (member.get_node_type () == Json.NodeType.ARRAY) {
                    var list = member.get_array ();
                    /* TODO This should complain if multiple types were set */
                    var arr_type = list.get_element (0).get_value_type ();
                    Variant[] arr = {};
                    VariantType val_type = VariantType.STRING;
                    for (int i = 0; i < list.get_length (); i++) {
                        var arr_member = list.get_element (i);
                        if (arr_type.is_a (typeof (string))) {
                            arr += new Variant.string (arr_member.get_string ());
                            val_type = VariantType.STRING;
                        } else if (arr_type.is_a (typeof (int64))) {
                            arr += new Variant.int64 (arr_member.get_int ());
                            val_type = VariantType.INT64;
                        } else if (arr_type.is_a (typeof (bool))) {
                            arr += new Variant.boolean (arr_member.get_boolean ());
                            val_type = VariantType.BOOLEAN;
                        } else if (arr_type.is_a (typeof (double))) {
                            arr += new Variant.double (arr_member.get_double ());
                            val_type = VariantType.DOUBLE;
                        }
                    }
                    if (arr.length > 0) {
                        properties.@set (name, new Variant.array (val_type, arr));
                    }
                } else if (member.get_node_type () == Json.NodeType.VALUE) {
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
     *
     * @return Content of the node as a string.
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
                value = prop.get_string ();
            } else if (prop.is_of_type (VariantType.INT64)) {
                value = ((int) prop.get_int64 ()).to_string ();
            } else if (prop.is_of_type (VariantType.BOOLEAN)) {
                value = prop.get_boolean ().to_string ();
            } else if (prop.is_of_type (VariantType.DOUBLE)) {
                value = prop.get_double ().to_string ();
            } else if (prop.is_of_type (VariantType.ARRAY)) {
                value = "[ ";
                foreach (var item in prop) {
                    if (item.is_of_type (VariantType.STRING)) {
                        value += item.get_string ();
                    } else if (item.is_of_type (VariantType.INT64)) {
                        value += ((int) item.get_int64 ()).to_string ();
                    } else if (item.is_of_type (VariantType.BOOLEAN)) {
                        value += item.get_boolean ().to_string ();
                    } else if (item.is_of_type (VariantType.DOUBLE)) {
                        value += item.get_double ().to_string ();
                    }

                    if (!item.equal (prop.get_child_value (prop.n_children () - 1))) {
                        value += ", ";
                    }
                }
                value += " ]";
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
                        } else if (prop.is_of_type (VariantType.ARRAY)) {
                            builder.begin_array ();
                            foreach (var item in prop) {
                                if (item.is_of_type (VariantType.STRING)) {
                                    builder.add_string_value (item.get_string ());
                                } else if (item.is_of_type (VariantType.INT64)) {
                                    builder.add_int_value (item.get_int64 ());
                                } else if (item.is_of_type (VariantType.BOOLEAN)) {
                                    builder.add_boolean_value (item.get_boolean ());
                                } else if (item.is_of_type (VariantType.DOUBLE)) {
                                    builder.add_double_value (item.get_double ());
                                }
                            }
                            builder.end_array ();
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
                        } else if (prop.is_of_type (VariantType.ARRAY)) {
                            foreach (var item in prop) {
                                if (item.is_of_type (VariantType.STRING)) {
                                    value += item.get_string ();
                                } else if (item.is_of_type (VariantType.INT64)) {
                                    value += ((int) item.get_int64 ()).to_string ();
                                } else if (item.is_of_type (VariantType.BOOLEAN)) {
                                    value += item.get_boolean ().to_string ();
                                } else if (item.is_of_type (VariantType.DOUBLE)) {
                                    value += item.get_double ().to_string ();
                                }

                                if (!item.equal (prop.get_child_value (prop.n_children () - 1))) {
                                    value += ",";
                                }
                            }
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
                        obj->add_child (child.xml);
                    }
                }

                if (xml != null) {
                    xml = null;
                }
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
        var prop = properties.@get (key);
        if (prop.is_of_type (VariantType.STRING)) {
            return prop.get_string ();
        } else {
            throw new Dcs.ConfigError.NO_VALUE_FOUND (
                "No property was found with key " + key);
        }
    }

    /**
     * {@inheritDoc}
     */
    public override Gee.ArrayList<string> get_string_list (string ns,
                                                           string key)
                                                           throws GLib.Error {
        Gee.ArrayList<string> val = null;

        var prop = properties.@get (key);
        if (prop.is_of_type (VariantType.ARRAY)) {
            foreach (var item in prop) {
                if (item.is_of_type (VariantType.STRING)) {
                    if (val == null) {
                        val = new Gee.ArrayList<string> ();
                    }
                    val.add (item.get_string ());
                }
            }
        } else {
            throw new Dcs.ConfigError.PROPERTY_TYPE (
                "The property at " + key + " is not a string list");
        }

        return val;
    }

    /**
     * {@inheritDoc}
     */
    public override int get_int (string ns,
                                 string key)
                                 throws GLib.Error {
        var prop = properties.@get (key);
        if (prop.is_of_type (VariantType.INT64)) {
            return (int) prop.get_int64 ();
        } else {
            throw new Dcs.ConfigError.NO_VALUE_FOUND (
                "No property was found with key " + key);
        }
    }

    /**
     * {@inheritDoc}
     */
    public override Gee.ArrayList<int> get_int_list (string ns,
                                                     string key)
                                                     throws GLib.Error {
        Gee.ArrayList<int> val = null;

        var prop = properties.@get (key);
        if (prop.is_of_type (VariantType.ARRAY)) {
            foreach (var item in prop) {
                if (item.is_of_type (VariantType.INT64)) {
                    if (val == null) {
                        val = new Gee.ArrayList<int> ();
                    }
                    val.add ((int) item.get_int64 ());
                }
            }
        } else {
            throw new Dcs.ConfigError.PROPERTY_TYPE (
                "The property at " + key + " is not a string list");
        }

        return val;
    }

    /**
     * {@inheritDoc}
     */
    public override bool get_bool (string ns,
                                   string key)
                                   throws GLib.Error {
        var prop = properties.@get (key);
        if (prop.is_of_type (VariantType.BOOLEAN)) {
            return prop.get_boolean ();
        } else {
            throw new Dcs.ConfigError.NO_VALUE_FOUND (
                "No property was found with key " + key);
        }
    }

    /**
     * {@inheritDoc}
     */
    public override Gee.ArrayList<bool> get_bool_list (string ns,
                                                       string key)
                                                       throws GLib.Error {
        Gee.ArrayList<bool> val = null;

        var prop = properties.@get (key);
        if (prop.is_of_type (VariantType.ARRAY)) {
            foreach (var item in prop) {
                if (item.is_of_type (VariantType.BOOLEAN)) {
                    if (val == null) {
                        val = new Gee.ArrayList<bool> ();
                    }
                    val.add (item.get_boolean ());
                }
            }
        } else {
            throw new Dcs.ConfigError.PROPERTY_TYPE (
                "The property at " + key + " is not a string list");
        }

        return val;
    }

    /**
     * {@inheritDoc}
     */
    public override double get_double (string ns,
                                       string key) throws GLib.Error {
        var prop = properties.@get (key);
        if (prop.is_of_type (VariantType.DOUBLE)) {
            return prop.get_double ();
        } else {
            throw new Dcs.ConfigError.NO_VALUE_FOUND (
                "No property was found with key " + key);
        }
    }

    /**
     * {@inheritDoc}
     */
    public override Gee.ArrayList<double?> get_double_list (string ns,
                                                            string key)
                                                            throws GLib.Error {
        Gee.ArrayList<double?> val = null;

        var prop = properties.@get (key);
        if (prop.is_of_type (VariantType.ARRAY)) {
            foreach (var item in prop) {
                if (item.is_of_type (VariantType.DOUBLE)) {
                    if (val == null) {
                        val = new Gee.ArrayList<double?> ();
                    }
                    val.add (item.get_double ());
                }
            }
        } else {
            throw new Dcs.ConfigError.PROPERTY_TYPE (
                "The property at " + key + " is not a string list");
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
    public override Dcs.ConfigNode get_node (string ns,
                                             string key) throws GLib.Error {
        Dcs.ConfigNode val = null;

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
        if (properties.has_key (key)) {
            var prop = properties.@get (key);
            if (prop.is_of_type (VariantType.STRING)) {
                properties.@set (key, value);
            } else {
                throw new Dcs.ConfigError.PROPERTY_TYPE (
                    "Incorrect property type for " + key);
            }
        } else {
            throw new Dcs.ConfigError.NO_VALUE_SET (
                "No value available with name " + key);
        }
    }

    /**
     * {@inheritDoc}
     */
    public override void set_string_list (string ns,
                                          string key,
                                          string[] value) throws GLib.Error {
        if (properties.has_key (key)) {
            var prop = properties.@get (key);
            if (prop.is_of_type (VariantType.ARRAY)) {
                Variant[] arr = {};
                foreach (var item in value) {
                    arr += new Variant.string (item);
                }
                if (arr.length > 0) {
                    properties.@set (key, new Variant.array (VariantType.STRING, arr));
                }
            } else {
                throw new Dcs.ConfigError.PROPERTY_TYPE (
                    "Incorrect property type for " + key);
            }
        } else {
            throw new Dcs.ConfigError.NO_VALUE_SET (
                "No value available with name " + key);
        }
    }

    /**
     * {@inheritDoc}
     */
    public override void set_int (string ns,
                                  string key,
                                  int value) throws GLib.Error {
        if (properties.has_key (key)) {
            var prop = properties.@get (key);
            if (prop.is_of_type (VariantType.INT64)) {
                properties.@set (key, (int64) value);
            } else {
                throw new Dcs.ConfigError.PROPERTY_TYPE (
                    "Incorrect property type for " + key);
            }
        } else {
            throw new Dcs.ConfigError.NO_VALUE_SET (
                "No value available with name " + key);
        }
    }

    /**
     * {@inheritDoc}
     */
    public override void set_int_list (string ns,
                                       string key,
                                       int[] value) throws GLib.Error {
        if (properties.has_key (key)) {
            var prop = properties.@get (key);
            if (prop.is_of_type (VariantType.ARRAY)) {
                Variant[] arr = {};
                foreach (var item in value) {
                    arr += new Variant.int64 ((int64) item);
                }
                if (arr.length > 0) {
                    properties.@set (key, new Variant.array (VariantType.INT64, arr));
                }
            } else {
                throw new Dcs.ConfigError.PROPERTY_TYPE (
                    "Incorrect property type for " + key);
            }
        } else {
            throw new Dcs.ConfigError.NO_VALUE_SET (
                "No value available with name " + key);
        }
    }

    /**
     * {@inheritDoc}
     */
    public override void set_bool (string ns,
                                   string key,
                                   bool value) throws GLib.Error {
        if (properties.has_key (key)) {
            var prop = properties.@get (key);
            if (prop.is_of_type (VariantType.BOOLEAN)) {
                properties.@set (key, value);
            } else {
                throw new Dcs.ConfigError.PROPERTY_TYPE (
                    "Incorrect property type for " + key);
            }
        } else {
            throw new Dcs.ConfigError.NO_VALUE_SET (
                "No value available with name " + key);
        }
    }

    /**
     * {@inheritDoc}
     */
    public override void set_bool_list (string ns,
                                        string key,
                                        bool[] value) throws GLib.Error {
        if (properties.has_key (key)) {
            var prop = properties.@get (key);
            if (prop.is_of_type (VariantType.ARRAY)) {
                Variant[] arr = {};
                foreach (var item in value) {
                    arr += new Variant.boolean (item);
                }
                if (arr.length > 0) {
                    properties.@set (key, new Variant.array (VariantType.BOOLEAN, arr));
                }
            } else {
                throw new Dcs.ConfigError.PROPERTY_TYPE (
                    "Incorrect property type for " + key);
            }
        } else {
            throw new Dcs.ConfigError.NO_VALUE_SET (
                "No value available with name " + key);
        }
    }

    /**
     * {@inheritDoc}
     */
    public override void set_double (string ns,
                                     string key,
                                     double value) throws GLib.Error {
        if (properties.has_key (key)) {
            var prop = properties.@get (key);
            if (prop.is_of_type (VariantType.DOUBLE)) {
                properties.@set (key, value);
            } else {
                throw new Dcs.ConfigError.PROPERTY_TYPE (
                    "Incorrect property type for " + key);
            }
        } else {
            throw new Dcs.ConfigError.NO_VALUE_SET (
                "No value available with name " + key);
        }
    }

    /**
     * {@inheritDoc}
     */
    public override void set_double_list (string ns,
                                          string key,
                                          double[] value) throws GLib.Error {
        if (properties.has_key (key)) {
            var prop = properties.@get (key);
            if (prop.is_of_type (VariantType.ARRAY)) {
                Variant[] arr = {};
                foreach (var item in value) {
                    arr += new Variant.double (item);
                }
                if (arr.length > 0) {
                    properties.@set (key, new Variant.array (VariantType.DOUBLE, arr));
                }
            } else {
                throw new Dcs.ConfigError.PROPERTY_TYPE (
                    "Incorrect property type for " + key);
            }
        } else {
            throw new Dcs.ConfigError.NO_VALUE_SET (
                "No value available with name " + key);
        }
    }

    /**
     * {@inheritDoc}
     */
    public override void set_node (string ns,
                                   string key,
                                   Dcs.ConfigNode? value) throws GLib.Error {
        switch (format) {
        }
    }
}
