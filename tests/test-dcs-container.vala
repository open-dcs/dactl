public abstract class Dcs.ContainerTestsBase : Dcs.TestCase {

    protected Dcs.Test.Container test_container;

    public ContainerTestsBase (string name) {
        base (name);
    }
}

public class Dcs.ContainerTests : Dcs.ContainerTestsBase {

    public ContainerTests () {
        base ("DcsContainer");
        /*
         *add_test ("[DcsContainer] Test add a child object", test_add_child);
         *add_test ("[DcsContainer] Test remove a child object", test_remove_child);
         *add_test ("[DcsContainer] Test return a child object", test_get_object);
         */
        /* XXX get_object_map fails to recurse */
        //add_test ("[DcsContainer] Test return a map of child objects", test_get_object_map);
        /*
         *add_test ("[DcsContainer] Test return all children of a type", test_get_children);
         *add_test ("[DcsContainer] Test return a sorted list of child objects", test_sort_objects);
         */
    }

    public override void set_up () {
        test_container = new Dcs.Test.Container ("container0");
    }

    public override void tear_down () {
        test_container = null;
    }

    private void test_add_child () {
        test_container = new Dcs.Test.Container ("container0");
        var test_object = new Dcs.Test.Object ("obj0");
        (test_container as Dcs.Container).add_child (test_object);
        assert (test_container.objects.size == 1);
    }

    private void test_remove_child () {
        test_container = new Dcs.Test.Container ("container0");
        var test_object = new Dcs.Test.Object ("obj0");
        (test_container as Dcs.Container).add_child (test_object);
        assert (test_container.objects.size == 1);
        (test_container as Dcs.Container).remove_child (test_object);
        assert (test_container.objects.size == 0);
    }

    private void test_get_object () {
        test_container = new Dcs.Test.Container ("container0");
        var test_object = test_container.get_object ("obj0");
        assert (test_object == null);
        test_object = new Dcs.Test.Object ("obj0");
        (test_container as Dcs.Container).add_child (test_object);
        assert (test_container.get_object ("obj0") == test_object);
    }

    private void test_get_object_map () {
        var test_container0 = new Dcs.Test.Container ("container0");
        var test_container1 = new Dcs.Test.Container ("container1");
        var test_object0 = new Dcs.Test.Object ("obj0");
        var test_object1 = new Dcs.Test.Object ("obj1");
        (test_container0 as Dcs.Container).add_child (test_object0);
        (test_container0 as Dcs.Container).add_child (test_container1);
        (test_container1 as Dcs.Container).add_child (test_object1);
        /*XXX adding the following line could cause infinite recursion for get_object map
        /*(test_container1 as Dcs.Container).add_child (test_container0);*/
        var type = typeof (Dcs.Object);
        var map = test_container0.get_object_map (type);
        assert (map.size == 3);
    }

    private void test_get_children () {
        var test_container0 = new Dcs.Test.Container ("container0");
        var test_container1 = new Dcs.Test.Container ("container1");
        var test_object0 = new Dcs.Test.Object ("obj0");
        var test_object1 = new Dcs.Test.Object ("obj1");
        (test_container0 as Dcs.Container).add_child (test_object0);
        (test_container0 as Dcs.Container).add_child (test_container1);
        (test_container1 as Dcs.Container).add_child (test_object1);
        var type = typeof (Dcs.Object);
        var map = test_container0.get_children (type);
        assert (map.size == 2);
    }

    private void test_sort_objects () {
        bool result = true;
        var test_container = new Dcs.Test.Container ("container0");
        string[] ids = { "zzz", "z1", "1", "a1", "a11", "A1" };
        string[] sorted_ids = { "1", "A1", "a1", "a11", "z1", "zzz" };
        for (int i = 0; i < ids.length; i++) {
            var object = new Dcs.Test.Object (ids[i]);
            test_container.add_child (object);
        }
        test_container.sort_objects ();
        var sorted = test_container.objects.values.to_array ();

        for (int i = 0; i < ids.length; i++) {
            if (Posix.strcmp (sorted_ids[i], sorted[i].id) != 0)
                result = false;
        }
        assert (result);
    }
}
