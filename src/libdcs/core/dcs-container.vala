public errordomain Dcs.ContainerError {
    OBJECT_NOT_FOUND
}

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
     * Retrieve the object for a given ID.
     *
     * @param id ID of the object to return
     * @return The object if found, null otherwise
     */
    public abstract Dcs.Object @get (string id);

    /**
     * Update an object for a given ID, add if it does not exist already.
     *
     * @param id ID of the object to update
     */
    public abstract void @set (string id, Dcs.Object object);

    /**
     * Remove an object from the list.
     *
     * @param object The object to remove
     */
    /*
     *public abstract void @delete (Dcs.Object object)
     *                              throws GLib.Error;
     */

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
        objects.set (object.id, object);
        object_added (object.id);
    }

    /**
     * Remove an object to the array list of objects
     *
     * @param object object to remove from the list
     */
    public virtual void remove_child (Dcs.Object object) {
        GLib.Value value;
        objects.unset (object.id, out value);
        object_removed (object.id);
    }

    /**
     * Update the internal object list.
     *
     * @param val List of objects to replace the existing one
     */
    [Version (deprecated = true, deprecated_since = "0.2")]
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
