public abstract class Dcs.RefLinkerTestsBase : Dcs.TestCase {

    protected Dcs.RefLinker linker;

    public RefLinkerTestsBase (string name) {
        base (name);
    }
}

public class Dcs.RefLinkerTests : Dcs.RefLinkerTestsBase {

    private const string class_name = "DcsRefLinker";

    public RefLinkerTests () {
        base (class_name);
        add_test (@"[$class_name] Test process configuration nodes", test_process_nodes);
    }

    public override void set_up () {
        linker = Dcs.RefLinker.get_default ();
    }

    public override void tear_down () {
        linker = null;
    }

   /**
    * Node tree:
    *
    *                    node0
    *            __________|_________
    *           |                    |
    *         node00               node01
    *       ____|____            ____|____
    *      |         |          |         |
    *   node000   node001    node010   node011
    *
    *
    * Node references:
    *
    *    node00  -> node01, node010, node011
    *    node000 -> node01, node010, node011
    *    node001 -> node01, node010, node011
    *    node01  -> node00, node000, node001
    *    node010 -> node00, node000, node001
    *    node011 -> node00, node000, node001
    *
    */
    public void test_process_nodes () {
        var references = new Gee.ArrayList<string> ();

        /* Build node tree */
        var node0 = new Dcs.Test.Node ("node0");
        var node00 = new Dcs.Test.Node ("node00");
        var node000 = new Dcs.Test.Node ("node000");
        var node001 = new Dcs.Test.Node ("node001");
        var node01 = new Dcs.Test.Node ("node01");
        var node010 = new Dcs.Test.Node ("node010");
        var node011 = new Dcs.Test.Node ("node011");

        node0.set (node00.id, node00);
        node0.set (node01.id, node01);
        node00.set (node000.id, node000);
        node00.set (node001.id, node001);
        node01.set (node010.id, node010);
        node01.set (node011.id, node011);

        /* Build a reference list */
        var node00_references = new Gee.ArrayList<string> ();
        var node000_references = new Gee.ArrayList<string> ();
        var node001_references = new Gee.ArrayList<string> ();
        var node01_references = new Gee.ArrayList<string> ();
        var node010_references = new Gee.ArrayList<string> ();
        var node011_references = new Gee.ArrayList<string> ();

        linker.add_entry ("node00", "/node0/node01");
        linker.add_entry ("node00", "/node0/node01/node010");
        linker.add_entry ("node00", "/node0/node01/node011");

        linker.add_entry ("node000", "/node0/node01");
        linker.add_entry ("node000", "/node0/node01/node010");
        linker.add_entry ("node000", "/node0/node01/node011");

        linker.add_entry ("node001", "/node0/node01");
        linker.add_entry ("node001", "/node0/node01/node010");
        linker.add_entry ("node001", "/node0/node01/node011");

        linker.add_entry ("node01", "/node0/node00");
        linker.add_entry ("node01", "/node0/node00/node000");
        linker.add_entry ("node01", "/node0/node00/node001");

        linker.add_entry ("node010", "/node0/node00");
        linker.add_entry ("node010", "/node0/node00/node000");
        linker.add_entry ("node010", "/node0/node00/node001");

        linker.add_entry ("node011", "node0/node00");
        linker.add_entry ("node011", "node0/node00/node000");
        linker.add_entry ("node011", "node0/node00/node001");

        /*linker.print_table ();*/
        assert (linker.process_node (node0));
        /*linker.print_table ();*/
        linker.add_entry ("node011", "node0/node00/nodeFoo");
        try {
            linker.process_node (node0);
        } catch (Dcs.NodeError e) {
            assert (e is Dcs.NodeError.NULL_REFERENCE);
        }
    }
}
