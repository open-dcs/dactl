public interface Dcs.RefContainer : GLib.Object {

    /**
     * The list of references to objects.
     */
    protected abstract Gee.List<unowned Dcs.Node> references { get; private set; }

    /**
     * Add a reference to the list.
     *
     */
    public virtual void add_reference (Dcs.Node @ref) {
        if (references == null)  {
            references = new Gee.ArrayList<unowned Dcs.Node> ();
        }
        unowned Dcs.Node node = (Dcs.Node) @ref;
        (references as Gee.ArrayList<unowned Dcs.Node>).add (node);
    }
}
