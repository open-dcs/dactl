public class Dcs.UI.FooPage : Dcs.UI.FooObject {

    public int index { get; set; default = 0; }

    public string title { get; set; default = "OpenDCS Page"; }

    construct {
        objects = new Gee.TreeMap<string, Dcs.Object> ();
        widget = new Dcs.UI.FooPageWidget (this);
    }

    public FooPage () {
        debug ("Default construction doesn't do anything yet.");
    }

    public FooPage.from_xml_node (Xml.Node* node) {
        build_from_xml_node (node);
    }

    internal override void build_from_xml_node (Xml.Node* node) {
        string? value;
        string type;

        if (node->type == Xml.ElementType.ELEMENT_NODE &&
            node->type != Xml.ElementType.COMMENT_NODE) {
            id = node->get_prop ("id");

            /* Iterate through node children */
            for (Xml.Node *iter = node->children; iter != null; iter = iter->next) {
                if (iter->name == "property") {
                    switch (iter->get_prop ("name")) {
                        case "index":
                            value = iter->get_content ();
                            index = int.parse (value);
                            break;
                        case "title":
                            title = iter->get_content ();
                            break;
                        case "expand":
                            value = iter->get_content ();
                            widget.expand = bool.parse (value);
                            break;
                        case "fill":
                            value = iter->get_content ();
                            widget.fill = bool.parse (value);
                            break;
                        case "visible":
                            value = iter->get_content ();
                            widget.visible = bool.parse (value);
                            break;
                        default:
                            break;
                    }
                } else if (iter->name == "object") {
                    var factory = Dcs.UI.Factory.get_default ();
                    Dcs.Object? object;
                    try {
                        object = factory.make_object_from_node (iter);
                        type = iter->get_prop ("type");
                        debug ("Loading object of type `%s' with id `%s'", type, object.id);
                        if (object is Dcs.UI.FooObject) {
                            widget.put ((object as Dcs.UI.FooObject).widget, 0, 0);
                        }
                        add_child (object);
                    } catch (GLib.Error e) {
                        warning (e.message);
                    }
                }
            }
        }
    }
}

[GtkTemplate (ui = "/org/opendcs/libdcs/ui/foo-page.ui")]
public class Dcs.UI.FooPageWidget : Dcs.UI.FooWidget {

    public FooPageWidget (Dcs.UI.FooObject object) {
        this.object = object;
    }
}
