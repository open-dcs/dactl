private static int main (string[] args) {
    var json = """
      {
        "ds_b": {
          "type": "foo-data-series",
          "properties": {
            "length": 150
          }
        }
      }
    """;

    var factory = new Dcs.FooBarFactory ();
    var ds_a = factory.produce (typeof (Dcs.FooDataSeries));
    ds_a.id = "ds_a";

    var parser = new Json.Parser ();
    parser.load_from_data (json);
    var config = new Dcs.ConfigNode.from_json (parser.get_root ());
    var ds_b = factory.produce_from_config (config);

    ds_a.set_print_verbosity (true);
    stdout.printf (@"$ds_a\n");
    stdout.printf (@"$ds_b\n");

    return 0;
}
