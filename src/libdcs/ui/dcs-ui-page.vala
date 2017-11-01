/**
 * Page data model class that is configurable using the application builder.
 */
[GtkTemplate (ui = "/org/opendcs/libdcs/ui/page.ui")]
public class Dcs.UI.Page : Dcs.UI.CompositeWidget {

    public int index { get; set; default = 0; }

    public string title { get; set; default = "Page"; }

    /**
     * {@inheritDoc}
     */
    private Gee.Map<string, Dcs.Object> _objects;
    public override Gee.Map<string, Dcs.Object> objects {
        get { return _objects; }
        set { update_objects (value); }
    }

    [GtkChild]
    private Gtk.Viewport viewport;

    /**
     * Common object construction.
     */
    construct {
        id = "pg0";
        name = id;
        objects = new Gee.TreeMap<string, Dcs.Object> ();
    }

    /**
     * Default construction.
     */
    public Page () { }

    /**
     * Construction using an XML node.
     */
    public Page.from_xml_node (Xml.Node *node) {
        build_from_xml_node (node);
        name = id;
    }

    /**
     * {@inheritDoc}
     */
    public override void build_from_xml_node (Xml.Node *node) {
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
                            expand = bool.parse (value);
                            break;
                        case "fill":
                            value = iter->get_content ();
                            fill = bool.parse (value);
                            break;
                        case "visible":
                            value = iter->get_content ();
                            visible = bool.parse (value);
                            break;
                        default:
                            break;
                    }
                } else if (iter->name == "object") {
                    Dcs.Object? object = null;
                    type = iter->get_prop ("type");
                    /**
                     * XXX will need to add checks for pnid and plugin types
                     *     when they get implemented
                     */
                    switch (type) {
                        case "box":
                            object = new Dcs.UI.Box.from_xml_node (iter);
                            break;
                        case "grid":
                            //object = new Dcs.UI.Grid.from_xml_node (iter);
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

    public void add_child (Dcs.Object object) {
        // For testing
        /*
         *if (object.id == "box0") {
         *    (object as Gtk.Widget).get_style_context ().add_class ("test0");
         *}
         */

        (base as Dcs.Container).add_child (object);
        //objects.set (object.id, object);
        debug ("Attempting to add widget `%s' to page `%s'", object.id, id);
        if (object is Dcs.UI.CustomWidget)
            viewport.add (object as Dcs.UI.CustomWidget);
        else if (object is Dcs.UI.CompositeWidget)
            viewport.add (object as Dcs.UI.CompositeWidget);
    }

    /**
     * {@inheritDoc}
     */
    public override void update_objects (Gee.Map<string, Dcs.Object> val) {
        _objects = val;
    }
}
