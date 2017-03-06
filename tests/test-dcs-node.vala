public class Dcs.Test.Node : Dcs.Node { }

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
        add_test (@"[$class_name] Test ", test_);
    }

    public override void set_up () {
        node = new Dcs.Test.Node ();
    }

    public override void tear_down () {
        node = null;
    }

    private void test_ () {
    }
}
