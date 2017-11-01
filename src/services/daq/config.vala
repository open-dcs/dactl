/**
 * XXX The XML stuff will not work, maybe fix later, maybe remove entirely.
 */
public class Dcs.DAQ.Config : Dcs.ConfigFile {

    construct {
        children = new Gee.ArrayList<Dcs.ConfigNode> (
            (Gee.EqualDataFunc<Dcs.ConfigNode>) Dcs.ConfigNode.equals);
    }

    public Config.from_data (string data) {
        load_data (data);
    }

    public Config.from_file (string filename) {
        load_file (filename);
    }

    /**
     * XXX In a class that actually implements this functionality this should
     *     be a constructor with a .from_data (...).
     */
    public void load_data (string data) throws GLib.Error {
        /* Test if the data is JSON by attempting to load it */
        try {
            var parser = new Json.Parser ();
            parser.load_from_data (data);
            format = Dcs.ConfigFormat.JSON;
            if (json != null) {
                json = null;
            }
            json = Dcs.ConfigJson.load_data (data);
        } catch (GLib.Error e) {
            format = Dcs.ConfigFormat.INVALID;
        }

        /* Test if the data is XML by attempting to load it */
        if (this.format != Dcs.ConfigFormat.JSON) {
            Xml.Doc* doc = Xml.Parser.parse_memory (data, data.length);
            if (doc != null) {
                format = Dcs.ConfigFormat.XML;
                if (xml != null) {
                    xml = null;
                }
                xml = Dcs.ConfigXml.load_data (data, "dcs");
            } else {
                format = Dcs.ConfigFormat.INVALID;
                throw new Dcs.ConfigError.INVALID_FORMAT (
                    "Invalid format provided");
            }
        }

        populate_config_tree ();
    }

    /**
     * XXX In a class that actually implements this functionality this should
     *     be a constructor with a .from_file (...).
     */
    public void load_file (string filename) throws GLib.Error {
        /* Test if the data is JSON by attempting to load it */
        try {
            var parser = new Json.Parser ();
            parser.load_from_file (filename);
            format = Dcs.ConfigFormat.JSON;
            if (json != null) {
                json = null;
            }
            json = Dcs.ConfigJson.load_file (filename);
        } catch (GLib.Error e) {
            format = Dcs.ConfigFormat.INVALID;
        }

        /* Test if the data is XML by attempting to load it */
        if (this.format != Dcs.ConfigFormat.JSON) {
            Xml.Doc* doc = Xml.Parser.parse_file (filename);
            if (doc != null) {
                format = Dcs.ConfigFormat.XML;
                if (xml != null) {
                    xml = null;
                }
                xml = Dcs.ConfigXml.load_file (filename, "dcs");
            } else {
                format = Dcs.ConfigFormat.INVALID;
                throw new Dcs.ConfigError.INVALID_FORMAT (
                    "Invalid format provided");
            }
        }

        populate_config_tree ();
    }

    protected override void populate_config_tree () throws GLib.Error {
        try {
            switch (format) {
                case Dcs.ConfigFormat.JSON:
                    var daq = Dcs.ConfigJson.get_namespace_nodes (json, "daq");
                    foreach (var node in daq) {
                        //debug ("\n" + Json.to_string (node, true));
                        children.add (new Dcs.ConfigNode.from_json (node));
                    }
                    var net = Dcs.ConfigJson.get_namespace_nodes (json, "net");
                    foreach (var node in net) {
                        //debug ("\n" + Json.to_string (node, true));
                        children.add (new Dcs.ConfigNode.from_json (node));
                    }
                    break;
                case Dcs.ConfigFormat.XML:
                    /* FIXME This is wrong */
                    var nodes = Dcs.ConfigXml.get_child_nodes (xml);
                    foreach (var node in nodes) {
                        children.add (new Dcs.ConfigNode.from_xml (node));
                    }
                    break;
                default:
                    break;
            }
        } catch (GLib.Error e) {
            throw e;
        }
    }
}
