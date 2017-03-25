private void json_node () {
    string data = """
      {
        "foo0": {
          "type": "foo-node",
          "properties": {
            "val-a": 1,
            "val-b": "one",
            "val-c": true,
            "val-d": 1.1,
            "val-e": [1, 2],
            "val-f": ["one", "two"],
            "val-g": [true, false],
            "val-h": [1.1, 2.2]
          },
          "references": [
            "/foo1", "/foo2"
          ],
          "objects": {
            "bar0": {
              "type": "bar-node",
              "properties": {
                "val-a": 2,
                "val-b": "two",
                "val-c": false
              },
              "references": [
                "../bar1"
              ]
            },
            "bar1": {
              "type": "bar-node",
              "properties": {
                "val-a": 2,
                "val-b": "two",
                "val-c": false
              },
              "references": [
                "../bar0"
              ]
            }
          }
        }
      }
    """;

    var parser = new Json.Parser ();
    try {
        parser.load_from_data (data);
    } catch (Error e) {
        critical (e.message);
    }

    var json = parser.get_root ();
    var node = new Dcs.ConfigNode.from_json (json);

    stdout.printf (@"JSON:\n\n$node\n");

    try {
        var child = node.get_node ("foo0", "/foo0/bar0");
        stdout.printf (@"Child JSON:\n\n$child\n");
    } catch (GLib.Error e) {
        critical (e.message);
    }

    node.set_format (Dcs.ConfigFormat.XML);
    stdout.printf ("Resulting XML after format conversion:\n\n");
    node.print_xml ();
    stdout.printf ("\n");
}

private void xml_node () {
    string xml_data = """
      <object type="foo-node" id="foo0">
        <property name="val-a">1</property>
        <property name="val-b">one</property>
        <property name="val-c">true</property>
        <property name="val-d">1.1</property>
        <property name="val-e">1,2</property>
        <property name="val-f">one,two</property>
        <property name="val-g">true,false</property>
        <property name="val-h">1.1,2.2</property>
        <reference path="/foo1"/>
        <reference path="/foo2"/>
        <object type="bar-node" id="bar0">
          <property name="val-a">2</property>
          <property name="val-b">two</property>
          <property name="val-c">false</property>
          <reference path="../bar1"/>
        </object>
        <object type="bar-node" id="bar1">
          <property name="val-a">2</property>
          <property name="val-b">two</property>
          <property name="val-c">false</property>
          <reference path="../bar0"/>
        </object>
      </object>
    """;

    Xml.Doc *doc = Xml.Parser.parse_memory (xml_data, xml_data.length);
    Xml.XPath.Context *ctx = new Xml.XPath.Context (doc);
    Xml.XPath.Object *obj = ctx->eval_expression ("/object");
    assert_nonnull (obj);

    var xml = obj->nodesetval->item (0);
    var node = new Dcs.ConfigNode.from_xml (xml);

    stdout.printf (@"XML:\n\n$node\n");

    node.set_format (Dcs.ConfigFormat.JSON);
    stdout.printf ("Resulting JSON after format conversion:\n\n");
    node.print_json ();
}

private void construct_node () {
    var node = new Dcs.ConfigNode ("foo-node", "foo0", Dcs.ConfigFormat.JSON);
    var bar0 = new Dcs.ConfigNode ("bar-node", "bar0", Dcs.ConfigFormat.JSON);
    var bar1 = new Dcs.ConfigNode ("bar-node", "bar1", Dcs.ConfigFormat.JSON);
    var baz0 = new Dcs.ConfigNode ("baz-node", "baz0", Dcs.ConfigFormat.JSON);

    try {
        node.add_property ("val-a", VariantType.INT64);
        node.add_property ("val-b", VariantType.STRING);
        node.add_property ("val-c", VariantType.BOOLEAN);
        node.set_int ("bar2", "val-a", 3);
        node.set_string ("bar2", "val-b", "three");
        node.set_bool ("bar2", "val-c", true);
        node.add_reference ("/foo0/bar0");
        stdout.printf (@"\n\nConstructed node:\n\n$node\n");
        var properties = node.get_properties ();
        foreach (var key in properties.keys) {
            stdout.printf ("prop %s: %s\n", key, properties.@get (key).print (true));
        }
        foreach (var @ref in node.get_references ()) {
            stdout.printf ("ref: %s\n\n", @ref);
        }
        node.remove_property ("val-a");
        node.remove_reference ("/foo0/bar0");
        stdout.printf (@"Updated constructed node:\n\n$node\n");

        /*
         *message ("start");
         *node.set_node ("test", "/", null);
         *message ("start");
         *node.set_node ("test", "/./", null);
         */
        node.set_node ("test", "/foo0/bar0", bar0);
        node.set_node ("test", "foo0/bar1", bar1);
        node.set_node ("test", "foo0/bar0/baz0", baz0);
        stdout.printf (@"Added nodes:\n\n$node\n");
        stdout.printf (@"Added subsub node:\n\n$bar0\n");
        node.set_node ("test", "foo0/bar0", null);
        node.set_node ("test", "/foo0/bar1", null);
        stdout.printf (@"Removed nodes:\n\n$node\n");
        /*
         *node.set_node ("test", "foo0", null);
         */
    } catch (GLib.Error e) {
        critical (e.message);
    }
}

private static int main (string[] args) {
    json_node ();
    xml_node ();
    construct_node ();

    /*
     *var path = new Dcs.Path ("../test");
     *stdout.printf (path.expand () + "\n");
     *path.data = "./test";
     *stdout.printf (path.expand () + "\n");
     */

    return 0;
}
