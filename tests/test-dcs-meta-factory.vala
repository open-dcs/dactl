public abstract class Dcs.MetaFactoryTestsBase : Dcs.TestCase {

    //protected Dcs.MetaFactory test_factory;

    public MetaFactoryTestsBase (string name) {
        base (name);
    }
}

public class Dcs.MetaFactoryTests : Dcs.MetaFactoryTestsBase {

    public MetaFactoryTests () {
        base ("DcsMetaFactory");
        add_test ("[DcsMetaFactory] Test get default (singleton)",
                                                              test_get_default);

        add_test ("[DcsMetaFactory] Test register factory",
                                                         test_register_factory);
        add_test ("[DcsMetaFactory] Test make object map", test_make_object_map);
        add_test ("[DcsMetaFactory] Test make object", test_make_object);
        add_test ("[DcsMetaFactory] Test make object from node",
                                                    test_make_object_from_node);
    }

    public override void set_up () {
        //nothing required
    }

    public override void tear_down () {
        //nothing required
    }

    public void test_get_default () {
        /* This is the only test where the common class isn't relevant */
        var app_factory = Dcs.MetaFactory.get_default ();

        assert_true (app_factory is Dcs.MetaFactory);
    }

    public void test_register_factory () {
        var factory = new Dcs.Test.Factory ();
        Dcs.MetaFactory.register_factory (factory);
    }

    public void test_make_object_map () {

    }

    public void test_make_object () {

    }

    public void test_make_object_from_node () {

    }
}
