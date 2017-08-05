public errordomain Dcs.ReferenceError {
    DOES_NOT_EXIST,
    EMPTY_LIST
}

public interface Dcs.RefContainer : GLib.Object {

    /**
     * The list of references to objects.
     */
    protected abstract Gee.List<unowned Dcs.Node> references { get; private set; }

    public signal void reference_added (string ref_id);

    public signal void reference_removed (string ref_id);

    /**
     * Add a reference to the list.
     *
     */
    public virtual bool add_reference (Dcs.Node @ref) {
        if (references == null)  {
            /* XXX probably incorrect to use id comparison for references */
            references = new Gee.ArrayList<unowned Dcs.Node> (
                            (Gee.EqualDataFunc) Dcs.Object.equal);
        }

        unowned Dcs.Node node = (Dcs.Node) @ref;
        bool ret = (references as Gee.ArrayList<unowned Dcs.Node>).add (node);
        if (ret) {
            reference_added (@ref.id);
        }

        return ret;
    }

    /**
     * Remove a reference from a list.
     */
    public virtual bool remove_reference (Dcs.Node @ref) throws GLib.Error {
        if (references == null) {
            throw new Dcs.ReferenceError.EMPTY_LIST (
                "No references have been added to the container.");
        } else if (!references.contains (@ref)) {
            throw new Dcs.ReferenceError.DOES_NOT_EXIST (
                "The reference requested to remove does not exist.");
        }

        bool ret = references.remove (@ref);
        if (ret) {
            reference_removed (@ref.id);
        }

        return ret;
    }
}
