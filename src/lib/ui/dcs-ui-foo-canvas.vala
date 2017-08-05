public class Dcs.UI.FooCanvas : Dcs.UI.FooObject {

    construct {
        objects = new Gee.TreeMap<string, Dcs.Object> ();
        widget = new Dcs.UI.FooCanvasWidget (this);
    }

    public FooCanvas () {
        debug ("Default construction doesn't do anything yet.");
    }

    public FooCanvas.from_xml_node (Xml.Node* node) {
        build_from_xml_node (node);
    }

    internal override void build_from_xml_node (Xml.Node* node) throws GLib.Error {
        string? value;
        string type;

        if (node->type == Xml.ElementType.ELEMENT_NODE &&
            node->type != Xml.ElementType.COMMENT_NODE) {
            id = node->get_prop ("id");

            /* Iterate through node children */
            for (Xml.Node *iter = node->children; iter != null; iter = iter->next) {
                if (iter->name == "property") {
                    switch (iter->get_prop ("name")) {
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
                    Dcs.Object? object = null;
                    type = iter->get_prop ("type");
                    switch (type) {
                        /* TODO check for simple drawing types here? */
                        default:
                            break;
                    }

                    /* no point adding an object type that isn't recognized */
                    if (object != null) {
                        debug ("Loading object of type `%s' with id `%s'", type, object.id);
                        add_child (object);
                    }
                }
            }
        }
    }
}

[GtkTemplate (ui = "/org/opendcs/libdcs/ui/foo-canvas.ui")]
public class Dcs.UI.FooCanvasWidget : Dcs.UI.FooWidget {

    [GtkChild]
    private Gtk.DrawingArea area;

    public FooCanvasWidget (Dcs.UI.FooObject object) {
        this.object = object;
    }

    [GtkCallback]
    private bool configure_event_cb (Gdk.EventConfigure event) {
        debug ("configure event");
        return false;
    }

    [GtkCallback]
    private bool button_press_event_cb (Gdk.EventButton event) {
        return false;
    }

    [GtkCallback]
    private bool button_release_event_cb (Gdk.EventButton event) {
        return false;
    }
}
