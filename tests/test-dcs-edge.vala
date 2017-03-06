public class Dcs.Test.Edge : Dcs.Edge, Dcs.AbstractBuildable { }

public abstract class Dcs.EdgeTestsBase : Dcs.TestCase {

    protected Dcs.Edge edge;

    public EdgeTestsBase (string name) {
        base (name);
    }
}

public class Dcs.EdgeTests : Dcs.EdgeTestsBase {

    private const string class_name = "DcsEdge";

    public EdgeTests () {
        base (class_name);
        add_test (@"[$class_name] Test ", test_);
    }

    public override void set_up () {
        edge = new Dcs.Test.Edge ();
    }

    public override void tear_down () {
        edge = null;
    }

    private void test_ () {
    }
}
