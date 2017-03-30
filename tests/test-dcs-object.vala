/**
 * Mock class to instantiate an interface for testing.
 */
public class Dcs.Test.Object : Dcs.AbstractObject {

    public Object (string id) {
        this.id = id;
    }
}

public abstract class Dcs.ObjectTestsBase : Dcs.TestCase {

    protected Dcs.Object test_object;

    public ObjectTestsBase (string name) {
        base (name);
    }
}

public class Dcs.ObjectTests : Dcs.ObjectTestsBase {

    public ObjectTests () {
        base ("DcsObject");
        add_test ("[DcsObject] Test ID property", test_id);
        add_test ("[DcsObject] Test equivalency", test_equal);
        add_test ("[DcsObject] Test comparison", test_compare);
        add_test ("[DcsObject] Test string dump", test_to_string);
        add_test ("[DcsObject] Test serialize", test_serialize);
        add_test ("[DcsObject] Test deserialize", test_deserialize);
    }

    public override void set_up () {
        test_object = new Dcs.Test.Object ("obj0");
    }

    public override void tear_down () {
        test_object = null;
    }

    public void test_id () {
        assert (test_object.id == "obj0");
    }

    private void test_equal () {
        var object = new Dcs.Test.Object (test_object.id);
        assert (test_object.equal (test_object, object));
    }

    private void test_compare () {
        var object = new Dcs.Test.Object (test_object.id);
        assert (Dcs.Object.compare (test_object, object) == 0);
    }

    private void test_to_string () {
        var object = new Dcs.Test.Object (test_object.id);
        /* 4 lines of output ending in a newline */
        var nlines = test_object.to_string ().split ("\n").length - 1;
        assert (nlines == 4);
    }

    private void test_serialize () {
        assert ((test_object as Dcs.Serializable).serialize () == "<object id=\"obj0\"/>");
    }

    private void test_deserialize () {
        var data = "<object id=\"obj1\"/>";
        (test_object as Dcs.Serializable).deserialize (data);
        assert (test_object.id == "obj1");
        try {
            /* Generate an error */
            data = "<object/>";
            (test_object as Dcs.Serializable).deserialize (data);
        } catch (Dcs.SerializationError e) {
            assert_nonnull ((void *) e);
            assert (test_object.id == "obj1");
        }
    }
}
