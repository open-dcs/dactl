public errordomain Dcs.NodeError {
    PARENT_EXISTS,
    CIRCULAR_REFERENCE,
    NULL_REFERENCE
}

public class Dcs.Node : Gee.TreeMap<string, Dcs.Node>,
                        Dcs.Object, Dcs.Serializable, Dcs.RefContainer {

    private bool verbose = false;

    /**
     * {@inheritDoc}
     */
    public virtual string id { get; set; }

    /**
     * {@inheritDoc}
     */
    protected virtual Gee.List<unowned Dcs.Node> references { get; protected set; }

    /**
     * Parent of the node, null if this is the root.
     */
    public Dcs.Node parent { get; set; default = null; }

    /**
     * Emitted whenever an node as been added.
     *
     * @param id the ID of the node that was added
     */
    public signal void node_added (string id);

    /**
     * Emitted whenever an node as been removed.
     *
     * @param id the ID of the node that was removed
     */
    public signal void node_removed (string id);

    /**
     * Emitted whenever an node as been updated.
     *
     * @param id the ID of the node that was updated
     */
    public signal void node_updated (string id);

    /**
     * Used by implementing classes to request a child node for addition.
     *
     * @param id the ID of the node that was requested
     */
    public signal void request_node (string id);

    public Node () {
        this.node_added.connect ((node_id) => {
            debug ("Node %s was added to %s", node_id, id);
        });
    }

    /**
     * Used by implementing class to request an reference node for addition.
     *
     * @param id the ID of the reference node that was requested
     */
    public signal void request_reference (string id);

    construct {
        references = new Gee.ArrayList<unowned Dcs.Node> ();
    }

    /**
     * {@inheritDoc}
     */
    public override void @set (string key, Dcs.Node node) {
        try {
            add (node);
        } catch (Dcs.NodeError e) {
            debug (e.message);
        }
    }

    /**
     * {@inheritDoc}
     */
    public override bool @unset (string key, out Dcs.Node node) {
        bool ret;

        try {
            remove (node);
            ret = true;
        } catch (Dcs.NodeError e) {
            debug (e.message);
            ret = false;
        }

        return ret;
    }

    /**
     * Increase to_string verbosity to display parent properties.
     *
     * @param value `true` to print parent properties, `false` to hide them.
     */
    public void set_print_verbosity (bool value) {
        verbose = value;
    }

    /**
     * Add a node.
     *
     * @param node a node to be added
     */
    public virtual void add (Dcs.Node node) throws Dcs.NodeError {
        var descendants = node.get_descendants (typeof (Dcs.Node));

        if (node.parent != null) {
            throw new Dcs.NodeError.PARENT_EXISTS (
                "Node %s already has parent %s", id, parent.id);
        } else if (descendants.contains (this)) {
            /* XXX is this accurate? what if a descendant has the same ID?
             * maybe this should be based off the path instead */
            throw new Dcs.NodeError.CIRCULAR_REFERENCE (
                "Node %s contains itself as a descendant", id);
        } else if (has_key (node.id)) {
            throw new Dcs.NodeError.DUPLICATE_ID (
                "Node %s already contains a child with the ID %s", id, node.id);
        } else {
            base.@set (node.id, node);
            node.parent = this;
            node_added (node.id);
        }
    }

    /**
     * Remove a node.
     *
     * @param node node to remove from the list
     */
    public virtual void remove (Dcs.Node node) {
        Dcs.Node value;
        base.unset (node.id, out value);
        value.parent = null;
        node_removed (node.id);
    }

    /**
     * Get a node from a path identifier
     *
     * @param path A path to a node
     *
     * @return A node with the given path
     */
    public virtual Dcs.Node retrieve (string path) throws Dcs.NodeError {
        Dcs.Node? result = this;
        string [] tokens;
        string p = path;

        if (path.has_prefix ("/")) {
            p  = path.substring (1, path.length - 1);
        }

        tokens = p.split ("/");
        if (tokens[0] == id) {
            for (int i = 1; i < tokens.length; i++) {
                var next = result.get (tokens[i]);
                if (next != null) {
                    result = next;
                } else {
                    result = null;
                }
                if (result == null) {
                throw new Dcs.NodeError.NULL_REFERENCE (
                                         "Node with path %s does not exist", p);
                }
            }
        }

        return result;
    }

    /**
     * Retrieves a list of all nodes of a certain type.
     *
     * {{{
     *  // XXX TBD Dcs.UI does not use node yet. It still uses Dcs.Container
     *  var pg_list = node.get_descendants (typeof (Dcs.UI.Page));
     * }}}
     *
     * @param type class type to retrieve
     *
     * @return list of all nodes of a certain class type, `null' if empty
     */
    public virtual Gee.ArrayList<Dcs.Node>? get_descendants (Type type) {
        var list = new Gee.ArrayList<Dcs.Node> ();

        foreach (var node in values) {
            if (node.get_type ().is_a (type)) {
                list.add (node);
            }
            if (node is Dcs.Node) {
                var sub_list = (node as Dcs.Node).get_descendants (type);
                foreach (var sub_node in sub_list) {
                    if (sub_node.get_type ().is_a (type)) {
                        list.add (sub_node);
                    }
                }
            }
        }

        //if (list.size > 0) {
            return list;
        //} else {
            //return null;
        //}
    }

    /**
     * Retrieve a map of the children of a certain type.
     *
     * {{{
     *  // XXX TBD Dcs.UI does not use node yet. It still uses Dcs.Container
     *  var children = node.get_children (typeof (Dcs.UI.Box));
     * }}}
     *
     * @param type class type to retrieve
     *
     * @return list of all nodes of a certain class type, `null' if empty
     */
    public virtual Gee.ArrayList<Dcs.Node>? get_children (Type type) {
        Gee.ArrayList<Dcs.Node> list = new Gee.ArrayList<Dcs.Node> ();

        foreach (var node in values) {
            if (node.get_type ().is_a (type)) {
                list.add (node);
            }
        }

        //if (list.size > 0) {
            return list;
        //} else {
            //return null;
        //}
    }

    /**
     * Moves a node value from this node to another.
     */
    public void reparent (Dcs.Node? new_parent) {
        if (parent != null) {
            parent.remove (this);
            new_parent.add (this);
        }
    }

    /**
     * Recursively print the contents of the nodes map.
     *
     * @param depth current level of the node tree
     */
    public virtual void print_node (int depth = 0) {
        foreach (var node in values) {
            string indent = string.nfill (depth * 2, ' ');
            debug ("%s[%s: %s]", indent, node.get_type ().name (), node.id);
            if (node is Dcs.Node) {
                (node as Dcs.Node).print_node (depth + 1);
            }
        }
    }

    /**
     * {@inheritDoc}
     */
    public virtual string serialize () throws GLib.Error {
        return "{}";
    }

    /**
     * {@inheritDoc}
     */
    public virtual void deserialize (string data) throws GLib.Error {
        /* XXX do something */
    }

    /**
     * {@inheritDoc}
     */
    public virtual Json.Node json_serialize () throws GLib.Error {
        var builder = new Json.Builder ();
        builder.begin_object ();
        builder.set_member_name (id);
        builder.begin_object ();
        builder.set_member_name ("type");
        builder.add_string_value (get_type ().name ());
        builder.set_member_name ("properties");
        builder.begin_object ();
        /* TODO Use ParamSpec to fill in for default implementation */
        builder.end_object ();
        if (size > 0) {
            builder.begin_object ();
            foreach (var child in values) {
                /* FIXME Shouldn't ignore exception here */
                builder.add_value (child.json_serialize ());
            }
            builder.end_object ();
        }
        if (references != null) {
            if (references.size > 0) {
                builder.begin_array ();
                foreach (var @ref in references) {
                    builder.add_string_value (@ref.id);
                }
                builder.end_array ();
            }
        }
        builder.end_object ();
        builder.end_object ();

        var node = builder.get_root ();
        if (node == null) {
            throw new Dcs.SerializationError.SERIALIZE_FAILURE (
                "Failed to serialize publisher %s", id);
        }

        return node;
    }

    /**
     * {@inheritDoc}
     */
    public virtual void json_deserialize (Json.Node node) throws GLib.Error {
        var obj = node.get_object ();
        id = obj.get_members ().nth_data (0);
        var data = obj.get_object_member (id);

        /* XXX Not sure if it's best to iterate the ParamSpec list or leave
         * it up to the object that extends Node */
        if (data.has_member ("properties")) {
            var props = data.get_object_member ("properties");
        }

        /* TODO Test this */
        if (data.has_member ("objects")) {
            var objs = data.get_object_member ("objects");
            foreach (var child_id in objs.get_members ()) {
                if (has_key (child_id)) {
                    var child = @get (child_id);
                    var child_json = objs.get_member (child_id);
                    child.json_deserialize (child_json);
                }
            }
        }

        if (data.has_member ("references")) {
            var refs = data.get_array_member ("references");
            /* TODO Need to use the RefLinker table to do this */
        }
    }

    /**
     * Dump node data to a string
     *
     * Example output:
     *
     * {{{
     * """
     * FooNode (foo0)
     * --------------
     * Properties
     *   val-a:  1
     *   val-b:  one
     *   val-c:  true
     * References:
     *   /foo1
     *   /foo2
     * Objects:
     *   foo-a
     *   foo-b
     *   foo-c
     * """
     * }}}
     *
     * @return A string containing information about this node
     */
    public virtual string to_string () {
        var builder = new StringBuilder ();

        var type = get_type ();
        var parent_type = type.parent ();
        builder.append (type.name () + " (" + id + ")\n");
        for (var i = 0; i < 48; i++) {
            builder.append ("-");
        }
        builder.append ("\n\n Properties:\n\n");

        var ocl = (ObjectClass) type.class_ref ();
        var parent_ocl = (ObjectClass) parent_type.class_ref ();
        foreach (var spec in ocl.list_properties ()) {
            if (ParamFlags.READABLE in spec.flags) {
                Value value = Value (spec.value_type);
                get_property (spec.get_name (), ref value);
                var str = "";

                if (spec.value_type == typeof (string)) {
                    str = value.get_string ();
                } else if (spec.value_type == typeof (int)) {
                    str = value.get_int ().to_string ();
                } else if (spec.value_type == typeof (double)) {
                    str = value.get_double ().to_string ();
                } else if (spec.value_type == typeof (bool)) {
                    str = value.get_boolean ().to_string ();
                } else {
                    str = "(unknown)";
                }

                var prop = "%20s : %-20s\n".printf (spec.get_name (), str);

                if (verbose) {
                    builder.append (prop);
                } else {
                    if (parent_ocl.find_property (spec.get_name ()) == null) {
                        builder.append (prop);
                    }
                }
            }
        }

        return builder.str;
    }

    /**
     * Return the node tree as a string.
     *
     * Example output:
     *
     * {{{
     * """
     * model
     * ├── control
     * │   ├── ctl0
     * │   ├── ctl1
     * │   └── ctl2
     * ├── daq
     * │   ├── dev0
     * │   └── dev1
     * ├── log
     * │   ├── back0
     * │   └── back1
     * └── net
     *     ├── pub0
     *     └── pub1
     * """
     * }}}
     */
    public static string tree (Dcs.Node node, string parent_prefix = "") {
        string[] prefix_a = {"├─ ", "│  "};
        string[] prefix_b = {"└─ ", "   "};
        var builder = new StringBuilder ();
        if (parent_prefix == "") {
            builder.append (node.id + "\n");
        }
        for (var iter = node.bidir_map_iterator (); iter.has_next ();) {
            iter.next ();
            var child = iter.get_value ();
            if (child != null) {
                var prefix = (iter.has_next ()) ? prefix_a : prefix_b;
                builder.append (parent_prefix + prefix[0] + iter.get_key () + "\n");
                builder.append (Dcs.Node.tree (child, parent_prefix + prefix[1]));
            }
        }

        return builder.str;
    }
}
