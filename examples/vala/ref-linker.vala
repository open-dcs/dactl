/*
 * ideas:
 *
 * xml node from file
 *      Xml.Node* Dcs.ConfigXml.load_file (string filename, string ns) ->
 * config node from xml node
 *      ConfigNode.from_xml (unowned Xml.Node* node) ->
 * get a factory
 *      new Dcs.FooBarFactory () ->
 * make a Dcs node
 *      FooBarFactory.produce_from_config (ConfigNode config)
 *
 *
 * Make a Dcs node map from a list of config nodes
 * - make 3 Config nodes
 * - put them in a list
 *
 * Gee.Map<string, Dcs.Node> produce_map (Gee.List<ConfigNode> nodes)
 *
 * - get a node map from a factory
 *
 */
public void main () {
    stdout.printf ("Hello\n");
}

