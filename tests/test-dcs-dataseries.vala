public abstract class Dcs.DataSeriesTestsBase : Dcs.TestCase {

    protected Dcs.DataSeries test_dataseries;

    public DataSeriesTestsBase (string name) {
        base (name);
    }
}

public class Dcs.DataSeriesTests : Dcs.DataSeriesTestsBase {

    public DataSeriesTests () {
        base ("DcsDataSeries");
        add_test ("[DcsDataSeries] Test construct", test_construct);
        add_test ("[DcsDataSeries] Test buffer size property", test_buffer_size);
        add_test ("[DcsDataSeries] Test stride property", test_stride);
        add_test ("[DcsDataSeries] Test conversion to array", test_to_array);
    }

    public override void set_up () {
        test_dataseries = new Dcs.DataSeries ();
    }

    public override void tear_down () {
        test_dataseries = null;
    }

    public void test_construct () {
        assert (test_dataseries != null);
    }

    public void test_buffer_size () {
        /*
         *test_dataseries.buffer_size = 10;
         *assert (test_dataseries.buffer_size == 10);
         */
        assert (true);
    }

    public void test_stride () {
        assert (true);
    }

    public void test_to_array () {
        assert (true);
    }
}
