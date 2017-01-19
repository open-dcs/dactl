public abstract class Dcs.ContainerTestsBase : Dcs.TestCase {

    protected Dcs.Container container;

    public ContainerTestsBase (string name) {
        base (name);
    }
}

public class Dcs.ContainerTests : Dcs.ContainerTestsBase {

    private const string class_name = "DcsContainer";

    public ContainerTests () {
        base (class_name);
        add_test (@"[$class_name] Test set", test_set);
        add_test (@"[$class_name] Test get", test_get);
        add_test (@"[$class_name] Test unset", test_unset);
        add_test (@"[$class_name] Test foreach", test_foreach);
    }

    public override void set_up () {
        container = new Dcs.Test.Container ();
    }

    public override void tear_down () {
        container = null;
    }

    private void test_set () {
        debug ("Not implemented");
        assert (true);
    }

    private void test_get () {
        debug ("Not implemented");
        assert (true);
    }

    private void test_unset () {
        debug ("Not implemented");
        assert (true);
    }

    private void test_foreach () {
        debug ("Not implemented");
        assert (true);
    }
}
