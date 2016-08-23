/**
 * A common interface inherited by any object that has its own list of sub
 * objects.
 */
public interface Dcs.Container : GLib.Object {

    /**
     * The map collection of the objects that belong to the container.
     */
    public abstract Gee.Map<string, Dcs.Object> objects { get; set; }

    /**
     * Used by implementing classes to request a child object for addition.
     */
    public abstract signal void request_object (string id);

    /**
     * Add a object to the array list of objects
     *
     * @param object object to add to the list
     */
    //public abstract void add_child (Dcs.Object object);
    public virtual void add_child (Dcs.Object object) {
        objects.set (object.id, object);
    }

    /**
     * Remove an object to the array list of objects
     *
     * @param object object to remove from the list
     */
    public virtual void remove_child (Dcs.Object object) {
        GLib.Value value;
        objects.unset (object.id, out value);
    }

    /**
     * Update the internal object list.
     *
     * @param val List of objects to replace the existing one
     */
    public abstract void update_objects (Gee.Map<string, Dcs.Object> val);

    /**
     * Search the object list for the object with the given ID
     *
     * @param id ID of the object to retrieve
     * @return The object if found, null otherwise
     */
    public virtual Dcs.Object? get_object (string id) {
        Dcs.Object? result = null;

        if (objects.has_key (id)) {
            result = objects.get (id);
        } else {
            foreach (var object in objects.values) {
                if (object is Dcs.Container) {
                    result = (object as Dcs.Container).get_object (id);
                    if (result != null) {
                        break;
                    }
                }
            }
        }

        return result;
    }

    /**
     * Retrieves a map of all objects of a certain type.
     *
     * {{{
     *  var pg_map = ctr.get_object_map (typeof (Dcs.UI.Page));
     * }}}
     *
     * @param type class type to retrieve
     * @return map of all objects of a certain class type
     */
    public virtual Gee.Map<string, Dcs.Object> get_object_map (Type type) {
        var map = new Gee.TreeMap<string, Dcs.Object> ();
        foreach (var object in objects.values) {
            if (object.get_type ().is_a (type)) {
                map.set (object.id, object);
            } else if (object is Dcs.Container) {
                var sub_map = (object as Dcs.Container).get_object_map (type);
                foreach (var sub_object in sub_map.values) {
                    map.set (sub_object.id, sub_object);
                }
            }
        }
        return map;
    }

    /**
     * Retrieve a map of the children of a certain type.
     *
     * {{{
     *  var children = ctr.get_children (typeof (Dcs.UI.Box));
     * }}}
     *
     * @param type class type to retrieve
     * @return map of all objects of a certain class type
     */
    public virtual Gee.Map<string, Dcs.Object> get_children (Type type) {
        Gee.Map<string, Dcs.Object> map = new Gee.TreeMap<string, Dcs.Object> ();
        foreach (var object in objects.values) {
            if (object.get_type ().is_a (type)) {
                map.set (object.id, object);
            }
        }
        return map;
    }

    /**
     * Sort the contents of the objects map collection.
     */
    public virtual void sort_objects () {
        Gee.List<Dcs.Object> map_values = new Gee.ArrayList<Dcs.Object> ();

        map_values.add_all (objects.values);
        map_values.sort ((GLib.CompareDataFunc<Dcs.Object>?) Dcs.Object.compare);
        objects.clear ();
        foreach (Dcs.Object object in map_values) {
            objects.set (object.id, object);
        }
    }

    /**
     * Recursively print the contents of the objects map.
     *
     * @param depth current level of the object tree
     */
    public virtual void print_objects (int depth = 0) {
        foreach (var object in objects.values) {
            string indent = string.nfill (depth * 2, ' ');
            debug ("%s[%s: %s]", indent, object.get_type ().name (), object.id);
            if (object is Dcs.Container) {
                (object as Dcs.Container).print_objects (depth + 1);
            }
        }
    }
}
