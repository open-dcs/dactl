void main (string[] args) {
    Test.init (ref args);

    //TestSuite.get_root ().add_suite (new Dcs.ContextTests ().get_suite ());

    TestSuite.get_root ().add_suite (new Dcs.ObjectTests ().get_suite ());
    TestSuite.get_root ().add_suite (new Dcs.ConfigTests ().get_suite ());
    TestSuite.get_root ().add_suite (new Dcs.ConfigNodeTests ().get_suite ());
    TestSuite.get_root ().add_suite (new Dcs.ContainerTests ().get_suite ());
    TestSuite.get_root ().add_suite (new Dcs.DataSeriesTests ().get_suite ());
    TestSuite.get_root ().add_suite (new Dcs.MetaFactoryTests ().get_suite ());
    TestSuite.get_root ().add_suite (new Dcs.MessageTests ().get_suite ());
    TestSuite.get_root ().add_suite (new Dcs.NodeTests ().get_suite ());
    TestSuite.get_root ().add_suite (new Dcs.PointTests ().get_suite ());
    TestSuite.get_root ().add_suite (new Dcs.RefLinkerTests ().get_suite ());

    Test.message ("Execute core unit tests");
    Test.run ();
}
