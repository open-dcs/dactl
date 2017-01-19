public abstract class Dcs.GraphTestsBase : Dcs.TestCase {

    protected Dcs.Graph graph;

    public GraphTestsBase (string name) {
        base (name);
    }
}

public class Dcs.GraphTests : Dcs.GraphTestsBase {

    private const string class_name = "DcsGraph";

    public GraphTests () {
        base (class_name);
        add_test (@"[$class_name] Test ", test_);
    }

    public override void set_up () {
        //graph = new Dcs.Test.Graph ();
    }

    public override void tear_down () {
        //graph = null;
    }

    private void test_ () {
    }
}
