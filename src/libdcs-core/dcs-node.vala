public abstract class Dcs.Node : Gee.TreeMap<string, Dcs.Object>,
                                                            Dcs.Object,
                                                            Dcs.Buildable,
                                                            Dcs.Serializable,
                                                            Dcs.RefContainer {
    /**
     * {@inheritDoc}
     */
    public abstract string id { get; set; }

    protected abstract Xml.Node* config_node { get; set; }

    /**
     * Build the object using an XML node
     *
     * {@inheritDoc}
     */
    internal abstract void build_from_xml_node (Xml.Node* node)
                                                throws GLib.Error;
    /**
     * {@inheritDoc}
     */
    public abstract string serialize () throws GLib.Error;

    /**
     * {@inheritDoc}
     */
    public abstract void deserialize (string data) throws GLib.Error;
    /**

     * {@inheritDoc}
     */
    protected virtual Gee.Map<string, unowned Dcs.Node> references { get; private set; }

    /**
     * Parent of the node, null if this is the root.
     */
    public Dcs.Node parent { get; private set; default = null; }

    /**
     * Emitted whenever an object as been added.
     *
     * @param id the ID of the object that was added
     */
    public signal void object_added (string id);

    /**
     * Emitted whenever an object as been removed.
     *
     * @param id the ID of the object that was removed
     */
    public signal void object_removed (string id);

    /**
     * Used by implementing classes to request a child object for addition.
     *
     * @param id the ID of the object that was requested
     */
    public signal void request_object (string id);

    /**
     * Add a object to the array list of objects
     *
     * @param object object to add to the list
     */
    public virtual void add_child (Dcs.Object object) {
        set (object.id, object);
        object_added (object.id);
    }

    /**
     * Remove an object to the array list of objects
     *
     * @param object object to remove from the list
     */
    public virtual void remove_child (Dcs.Object object) {
        GLib.Value value;
        unset (object.id, out value);
        object_removed (object.id);
    }

    /**
     * Retrieves a list of all objects of a certain type.
     *
     * {{{
     *  XXX TBD Dcs.UI does not use node yet. It still uses Dcs.Container
     *  var pg_list = node.get_descendants (typeof (Dcs.UI.Page));
     * }}}
     *
     * @param type class type to retrieve
     * @return list of all objects of a certain class type
     */
    public virtual Gee.ArrayList<Dcs.Object> get_descendants (Type type) {
        message ("0");
        var list = new Gee.ArrayList<Dcs.Object> ();
        foreach (var object in values) {
            message ("00        %s", object.id);
            if (object.get_type ().is_a (type)) {
                message ("000       %s", object.id);
                list.add (object);
            }

            if (object is Dcs.Node) {
                message ("001       %s", object.id);
                var sub_list = (object as Dcs.Node).get_descendants (type);
                foreach (var sub_object in sub_list) {
                    message ("0010      %s", sub_object.id);
                    if (sub_object.get_type ().is_a (type)) {
                        message ("00100     %s", sub_object.id);
                        list.add (sub_object);
                    }
                }
            }
        }
        return list;
    }

    /**
     * Retrieve a map of the children of a certain type.
     *
     * {{{
     *  XXX TBD Dcs.UI does not use node yet. It still uses Dcs.Container
     *  var children = node.get_children (typeof (Dcs.UI.Box));
     * }}}
     *
     * @param type class type to retrieve
     * @return list of all objects of a certain class type
     */
    public virtual Gee.ArrayList<Dcs.Object> get_children (Type type) {
        Gee.ArrayList<Dcs.Object> list = new Gee.ArrayList<Dcs.Object> ();
        foreach (var object in values) {
            if (object.get_type ().is_a (type)) {
                list.add (object);
            }
        }
        return list;
    }

    /**
     * Recursively print the contents of the objects map.
     *
     * @param depth current level of the object tree
     */
    public virtual void print_objects (int depth = 0) {
        foreach (var object in values) {
            string indent = string.nfill (depth * 2, ' ');
            debug ("%s[%s: %s]", indent, object.get_type ().name (), object.id);
            if (object is Dcs.Node) {
                (object as Dcs.Node).print_objects (depth + 1);
            }
        }
    }
}
