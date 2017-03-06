public abstract class Dcs.PointTestsBase : Dcs.TestCase {

    protected Dcs.Point point;

    protected Dcs.SimplePoint? simple_point;

    protected Dcs.TriplePoint? triple_point;

    public PointTestsBase (string name) {
        base (name);
    }
}

public class Dcs.PointTests : Dcs.PointTestsBase {

    public PointTests () {
        base ("DcsPoint");
        add_test ("[DcsPoint] Test construct", test_construct);
        add_test ("[DcsPoint] Test point properties", test_point);
        add_test ("[DcsPoint] Test simple point properties", test_simple_point);
        add_test ("[DcsPoint] Test triple point properties", test_triple_point);
    }

    public override void set_up () {
        point = new Dcs.Point (1.0, 2.0);
        simple_point = Dcs.SimplePoint () { x = 1.0, y = 2.0 };
        triple_point = Dcs.TriplePoint () { a = 1.0, b = 2.0, c = 3.0 };
    }

    public override void tear_down () {
        point = null;
        simple_point = null;
        triple_point = null;
    }

    public void test_construct () {
        assert (point != null);
        assert (simple_point != null);
        assert (triple_point != null);
    }

    public void test_point () {
        double x = 0.0;
        double y = 0.0;
        double z = 0.0;
        point.@get ("x", out x);
        point.@get ("y", out y);
        assert (x == 1.0);
        assert (y == 2.0);
    }

    public void test_simple_point () {
        assert (simple_point.x == 1.0);
        assert (simple_point.y == 2.0);
        var type = typeof (Dcs.SimplePoint);
        assert (type.name () == "DcsSimplePoint");
    }

    public void test_triple_point () {
        assert (triple_point.a == 1.0);
        assert (triple_point.b == 2.0);
        assert (triple_point.c == 3.0);
        var type = typeof (Dcs.TriplePoint);
        assert (type.name () == "DcsTriplePoint");
    }
}
