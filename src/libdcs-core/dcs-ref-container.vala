public interface Dcs.RefContainer : GLib.Object {

    /**
     * The list of references to objects.
     */
    protected abstract Gee.Map<string, unowned Dcs.Node> references { get; private set; }

    /**
     * Add a reference to the list.
     *
     * @param ref The node to add as a reference.
     */
    public virtual void add (Dcs.Node @ref) {
        if (references == null)  {
            references = new Gee.TreeMap<string, unowned Dcs.Node> ();
        }
        unowned Dcs.Node node = (Dcs.Node) @ref;
        (references as Gee.TreeMap<string, unowned Dcs.Node>).@set (@ref.id, node);
    }
}
