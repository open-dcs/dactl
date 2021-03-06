/**
 * Dummy class to instantiate an interface for testing.
 */
public class Dcs.Test.Object : GLib.Object, Dcs.Object {

    public string id { get; set; }

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
        add_test ("[DcsObject] Test equivalency", test_equal);
        add_test ("[DcsObject] Test comparison", test_compare);
    }

    public override void set_up () {
        test_object = new Dcs.Test.Object ("obj0");
    }

    public override void tear_down () {
        test_object = null;
    }

    private void test_equal () {
        var object = new Dcs.Test.Object (test_object.id);
        assert (test_object.equal (test_object, object));
    }

    private void test_compare () {
        var object = new Dcs.Test.Object (test_object.id);
        assert (test_object.compare (object) == 0);
    }
}
