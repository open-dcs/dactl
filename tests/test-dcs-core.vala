void main (string[] args) {
    Test.init (ref args);

    //TestSuite.get_root ().add_suite (new Dcs.ContextTests ().get_suite ());

    TestSuite.get_root ().add_suite (new Dcs.ObjectTests ().get_suite ());

    Test.message ("Execute core unit tests");
    Test.run ();
}
