private void json_node () {
    string data = """
      {
        "foo0": {
          "type": "foo-node",
          "properties": {
            "val-a": 1,
            "val-b": "one",
            "val-c": true,
            "val-d": 1.5
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
        <property name="val-d">1.5</property>
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

private static int main (string[] args) {
    json_node ();
    xml_node ();

    return 0;
}
