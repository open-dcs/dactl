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
        add_test (@"[$class_name] Test add a child object", test_add_child);
        add_test (@"[$class_name] Test remove a child object", test_remove_child);
        add_test (@"[$class_name] Test return all objects of a type",
                                                          test_get_descendants);
        add_test (@"[$class_name] Test return children of a type", test_get_children);
        /*add_test (@"[$class_name] Test ", test_print_objects);*/
    }

    public override void set_up () {
        node = new Dcs.Test.Node ("test_node");
    }

    public override void tear_down () {
        node = null;
    }

    private void test_add_child () {
        var test_object = new Dcs.Test.Object ("obj0");
        node.add_child (test_object);
        assert (node.size == 1);
    }

    private void test_remove_child () {
        var test_object = new Dcs.Test.Object ("obj0");
        node.add_child (test_object);
        assert (node.size == 1);
        node.remove_child (test_object);
        assert (node.size == 0);
    }

    private void test_get_descendants () {
        var node_a = new Dcs.Test.Node ("node_a");
        var node_b = new Dcs.Test.Container ("node_b");
        var object_0 = new Dcs.Test.Object ("object_0");
        var object_1 = new Dcs.Test.Object ("object_1");
        node_a.add_child (object_0);
        node_b.add_child (object_1);
        node_a.add_child (node_b);
        node.add_child (node_a);
        var type = typeof (Dcs.Object);
        /*
         *var list = node.get_descendants (type);
         */
        Dcs.Test.Node nd_a = node.get ("node_a") as Dcs.Test.Node;
        message ("got %s", nd_a.id);
        Dcs.Test.Node nd_b = nd_a.get ("node_b") as Dcs.Test.Node;
        message ("got %s", nd_b.id);
        var obj1 = nd_b.get ("object_1");
        message ("got %s", obj1.id);
        /*
         *foreach (var obj in list) {
         *    message ("%s", obj.id);
         *}
         *assert (list.size == 4);
         */
    }

    private void test_get_children () {

    }

/*
 *    private void test_print_objects () {
 *
 *    }
 */
}
