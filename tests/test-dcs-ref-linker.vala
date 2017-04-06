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
        var node0 = new Dcs.Test.Node ("node0");
        var node00 = new Dcs.Test.Node ("node00");
        var node000 = new Dcs.Test.Node ("node000");
        var node001 = new Dcs.Test.Node ("node000");
        var node01 = new Dcs.Test.Node ("node01");
        var node010 = new Dcs.Test.Node ("node010");
        var node011 = new Dcs.Test.Node ("node011");

        node0.set (node00.id, node00);
        node0.set (node01.id, node01);
        node00.set (node000.id, node000);
        node00.set (node001.id, node001);
        node01.set (node010.id, node010);
        node01.set (node011.id, node011);
    }
}
