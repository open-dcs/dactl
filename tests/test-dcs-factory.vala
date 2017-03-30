public abstract class Dcs.FactoryTestsBase : Dcs.TestCase {

    protected Dcs.Test.Factory factory;

    public FactoryTestsBase (string name) {
        base (name);
    }
}

public class Dcs.FactoryTests : Dcs.FactoryTestsBase {

    private const string class_name = "DcsFactory";

    public FactoryTests () {
        base (class_name);
        /*add_test (@"[$class_name] Test add a node", test_add);*/
    }

    public override void set_up () {
        factory = Dcs.Test.Factory.get_default ();
    }

    public override void tear_down () {
        factory = null;
    }

    private void test_build () {
        var node = factory.build ();
    }
}
