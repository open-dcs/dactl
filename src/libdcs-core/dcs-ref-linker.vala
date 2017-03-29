public class Dcs.RefLinker : GLib.Object {

    // node id | ref | path | satisfied

    private struct Entry {
        string id;
        string @ref;
        string path;
        bool satisfied;
    }

    private List<Entry> table;

    private static Once<Dcs.RefLinker> _instance;

    /**
     * Instantiate singleton for reference linker.
     *
     * @return Instance of the reference linker.
     */
    public static unowned Dcs.RefLinker get_default () {
        return _instance.once (() => { return new Dcs.RefLinker (); });
    }

    /**
     * TODO fill in
     *
     * @param nodes List of nodes to process internal reference requests.
     */
    public static void process_nodes (Gee.Container<Dcs.Node> nodes) {
        // ideas
        // - construct table of nodes and references
        //   take table and turn reference to absolute path
        //   get node at path as week ref
        foreach (var node in nodes) {
            node.reference_added.connect (do_something);
            foreach (var @ref in node.get_references ()) {
                // not sure what to do
            }
        }
    }
}
