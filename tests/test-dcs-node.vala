public abstract class Dcs.NodeTestsBase : Dcs.TestCase {

    protected Dcs.Node node;

    public NodeTestsBase (string name) {
        base (name);
    }
}

public class Dcs.NodeTests : Dcs.NodeTestsBase {

    private const string class_name = "DcsNode";

    public NodeTests () {
        base (class_name);
        add_test (@"[$class_name] Test add a node", test_add);
        add_test (@"[$class_name] Test remove a node", test_remove);
        add_test (@"[$class_name] Test return all nodes of a type",
                  test_get_descendants);
        add_test (@"[$class_name] Test return children of a type",
                  test_get_children);
        //add_test (@"[$class_name] Test ", test_print_node);
    }

    public override void set_up () {
        node = new Dcs.Test.Node ("test_node");
    }

    public override void tear_down () {
        node = null;
    }

    private void test_add () {
        var node_a = new Dcs.Test.Node ("node_a");
        try {
            node.add (node_a);
        } catch (Dcs.NodeError e) {
            assert (false);
        }
        assert (node.size == 1);
    }

    private void test_circular_references () {
        /* Tests that adding  circular reference is not possible */
        var node_a = new Dcs.Test.Node ("node_a");
        var node_b = new Dcs.Test.Node ("node_b");
        var node_c = new Dcs.Test.Node ("node_c");
        try {
            node_c.add (node_a);
            node_b.add (node_c);
            node_a.add (node_b);
        } catch (Dcs.NodeError e) {
            debug (e.message);
        }

        assert (node_a.size == 0);
        assert (node_b.size == 1);
        assert (node_c.size == 1);

        /* Tests that adding a parented node is not possible */
        node_a = new Dcs.Test.Node ("node_a");
        node_b = new Dcs.Test.Node ("node_b");
        node_c = new Dcs.Test.Node ("node_c");
        try {
            node_a.add (node_c);
            node_b.add (node_c);
        } catch (Dcs.NodeError e) {
            debug (e.message);
        }

        assert (node_a.size == 1);
        assert (node_b.size == 0);
    }

    private void test_remove () {
        var node_a = new Dcs.Test.Node ("node_a");
        node.add (node_a);
        assert (node.size == 1);
        node.remove (node_a);
        assert (node.size == 0);
    }

    private void test_get_descendants () {
        var node_a = new Dcs.Test.Node ("node_a");
        var node_b = new Dcs.Test.Node ("node_b");
        var node_0 = new Dcs.Test.Node ("node_0");
        var node_1 = new Dcs.Test.Node ("node_1");
        node_a.add (node_0);
        node_b.add (node_1);
        node_a.add (node_b);
        node.add (node_a);
        var list = node_a.get_descendants (typeof (Dcs.Node));
        assert (list.size == 3);
    }

    private void test_get_children () {
        /* Build node tree */
        var node0 = new Dcs.Test.Node ("node0");
        var node00 = new Dcs.Test.Node ("node00");
        var node000 = new Dcs.Test.Node ("node000");
        var node001 = new Dcs.Test.Node ("node001");
        var node01 = new Dcs.Test.Node ("node01");
        var node010 = new Dcs.Test.Node ("node010");
        var node011 = new Dcs.Test.Node ("node011");

        node0.add (node00);
        node0.add (node01);
        node00.add (node000);
        node00.add (node001);
        node01.add (node010);
        node01.add (node011);

        assert (node0.get_children (typeof (Dcs.Node)).contains (node00) &&
                node0.get_children (typeof (Dcs.Node)).contains (node01) &&
                node00.get_children (typeof (Dcs.Node)).contains (node000) &&
                node00.get_children (typeof (Dcs.Node)).contains (node001) &&
                node01.get_children (typeof (Dcs.Node)).contains (node010) &&
                node01.get_children (typeof (Dcs.Node)).contains (node011) &&
                (node0.get_children (typeof (Dcs.Node)).size == 2) &&
                (node00.get_children (typeof (Dcs.Node)).size == 2) &&
                (node000.get_children (typeof (Dcs.Node)).size == 0) &&
                (node01.get_children (typeof (Dcs.Node)).size == 2) &&
                (node010.get_children (typeof (Dcs.Node)).size == 0) &&
                (node011.get_children (typeof (Dcs.Node)).size == 0));
    }

    private void test_retrieve () {
        /* Build node tree */
        var node0 = new Dcs.Test.Node ("node0");
        var node00 = new Dcs.Test.Node ("node00");
        var node000 = new Dcs.Test.Node ("node000");
        var node001 = new Dcs.Test.Node ("node001");
        var node01 = new Dcs.Test.Node ("node01");
        var node010 = new Dcs.Test.Node ("node010");
        var node011 = new Dcs.Test.Node ("node011");

        node0.add (node00);
        node0.add (node01);
        node00.add (node000);
        node00.add (node001);
        node01.add (node010);
        node01.add (node011);

        var ret = node0.retrieve ("/node0/node00/node000");
        assert (Dcs.Object.equal (ret, node000));

        ret = node0.retrieve ("node0/node00/node000");
        assert (Dcs.Object.equal (ret, node000));
    }

/*
 *    private void test_print_node () {
 *
 *    }
 */
}
