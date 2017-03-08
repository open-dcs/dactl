public abstract class Dcs.AbstractContainer : Dcs.AbstractBuildable,
                                              Dcs.Container {
    /**
     * The map collection of the objects that belong to the container.
     */
    public Gee.Map<string, Dcs.Object> objects { get; set; }

    /**
     * Retrieve the object for a given ID.
     *
     * @param id ID of the object to return
     * @return The object if found, null otherwise
     */
    public virtual Dcs.Object @get (string id) {
        Dcs.Object result = null;

        if (objects.has_key (id)) {
            result = objects.get (id);
        } else {
            foreach (var object in objects.values) {
                if (object is Dcs.Container) {
                    result = (object as Dcs.Container).get (id);
                }
            }
        }

        return result;
    }

    /**
     * Update an object for a given ID, add if it does not exist already.
     *
     * @param id ID of the object to update
     */
    public virtual void @set (string id, Dcs.Object object) {
        // ...
    }

    /**
     * Remove an object from the list.
     *
     * @param object The object to remove
     */
    /*
     *public virtual void @delete (Dcs.Object object)
     *                             throws GLib.Error {
     *    GLib.Value value;
     *    if (objects.has_key (object.id)) {
     *        objects.unset (object.id, out value);
     *        object_removed (object.id);
     *    } else {
     *        throw new Dcs.ContainerError.OBJECT_NOT_FOUND (
     *            "The requested object with ID `%s' was not found", id);
     *    }
     *}
     */

    /**
     * {@inheritDoc}
     */
    /*
     *public virtual bool foreach (ForallFunc<Map.Entry<K,V>> f) {
     *    return iterator ().foreach (f);
     *}
     */

    /**
     * {@inheritDoc}
     */
    public virtual void update_objects (Gee.Map<string, Dcs.Object> val) {
        objects = val;
    }
}
