/**
 * Box class used to act as a layout for other interface classes.
 */
[GtkTemplate (ui = "/org/opendcs/libdcs/ui/box.ui")]
public class Dcs.UI.Box : Dcs.UI.CompositeWidget {

    //private Dcs.UI.Orientation _orientation = Dcs.UI.Orientation.HORIZONTAL;

    //public int spacing { get; set; default = 0; }

    /*
     *public Dcs.UI.Orientation orientation {
     *    get { return _orientation; }
     *    set {
     *        _orientation = value;
     *        box.orientation = _orientation.to_gtk ();
     *    }
     *}
     */

    //public bool homogeneous { get; set; default = false; }

    private Gee.Map<string, Dcs.Object> _objects;

    /**
     * {@inheritDoc}
     */
    public override Gee.Map<string, Dcs.Object> objects {
        get { return _objects; }
        set { update_objects (value); }
    }

    /*
     *[GtkChild]
     *private Gtk.Box box;
     */

    /**
     * Common object construction.
     */
    construct {
        id = "box0";
        objects = new Gee.TreeMap<string, Dcs.Object> ();
        spacing = 0;
        margin_top = 0;
        margin_right = 0;
        margin_bottom = 0;
        margin_left = 0;

        /*
         *this.notify["homogeneous"].connect (() => {
         *    box.homogeneous = homogeneous;
         *});
         */
    }

    /**
     * Default construction.
     */
    public Box () {
        debug ("empty construction");
    }

    /**
     * Construction using an XML node.
     */
    public Box.from_xml_node (Xml.Node *node) {
        build_from_xml_node (node);
    }

    /**
     * {@inheritDoc}
     */
    public override void build_from_xml_node (Xml.Node *node) {
        string type;
        string? value;

        if (node->type == Xml.ElementType.ELEMENT_NODE &&
            node->type != Xml.ElementType.COMMENT_NODE) {
            id = node->get_prop ("id");

            /* Iterate through node children */
            for (Xml.Node *iter = node->children; iter != null; iter = iter->next) {
                if (iter->name == "property") {
                    switch (iter->get_prop ("name")) {
                        case "homogeneous":
                            value = iter->get_content ();
                            homogeneous = bool.parse (value);
                            break;
                        case "orientation":
                            Dcs.UI.Orientation _orientation;
                            if (iter->get_content () == "horizontal")
                                _orientation = Dcs.UI.Orientation.HORIZONTAL;
                            else
                                _orientation = Dcs.UI.Orientation.VERTICAL;
                            orientation = _orientation.to_gtk ();
                            break;
                        case "expand":
                            value = iter->get_content ();
                            expand = bool.parse (value);
                            break;
                        case "fill":
                            value = iter->get_content ();
                            fill = bool.parse (value);
                            break;
                        case "spacing":
                            value = iter->get_content ();
                            spacing = int.parse (value);
                            break;
                        case "margin-top":
                            value = iter->get_content ();
                            margin_top = int.parse (value);
                            break;
                        case "margin-right":
                            value = iter->get_content ();
                            margin_right = int.parse (value);
                            break;
                        case "margin-bottom":
                            value = iter->get_content ();
                            margin_bottom = int.parse (value);
                            break;
                        case "margin-left":
                            value = iter->get_content ();
                            margin_left = int.parse (value);
                            break;
                        case "hexpand":
                            value = iter->get_content ();
                            hexpand = bool.parse (value);
                            break;
                        case "vexpand":
                            value = iter->get_content ();
                            vexpand = bool.parse (value);
                            break;
                        default:
                            break;
                    }
                } else if (iter->name == "object") {
                    Dcs.Object? object = null;
                    type = iter->get_prop ("type");
                    /**
                     * XXX will need to add checks for plugin widget types
                     *     when they get implemented
                     */
                    switch (type) {
                        case "box":
                            object = new Dcs.UI.Box.from_xml_node (iter);
                            break;
                        case "chart":
                            object = new Dcs.UI.Chart.from_xml_node (iter);
                            break;
                        case "rt-chart":
                            object = new Dcs.UI.RTChart.from_xml_node (iter);
                            break;
                        case "stripchart":
                            object = new Dcs.UI.StripChart.from_xml_node (iter);
                            break;
                        case "tree":
                            object = new Dcs.UI.ChannelTreeView.from_xml_node (iter);
                            break;
                        case "pnid":
                            object = new Dcs.UI.Pnid.from_xml_node (iter);
                            break;
                        case "pid":
                            object = new Dcs.UI.PidControl.from_xml_node (iter);
                            break;
                        case "ai":
                            object = new Dcs.UI.AIControl.from_xml_node (iter);
                            break;
                        case "ao":
                            object = new Dcs.UI.AOControl.from_xml_node (iter);
                            break;
                        case "digital":
                            object = new Dcs.UI.DigitalControl.from_xml_node (iter);
                            break;
                        case "exec":
                            object = new Dcs.UI.ExecControl.from_xml_node (iter);
                            break;
                        case "log":
                            object = new Dcs.UI.LogControl.from_xml_node (iter);
                            break;
                        case "polar-chart":
                            object = new Dcs.UI.PolarChart.from_xml_node (iter);
                            break;
                        case "video":
                            object = new Dcs.UI.VideoProcessor.from_xml_node (iter);
                            break;
                        case "rich-content":
                            object = new Dcs.UI.RichContent.from_xml_node (iter);
                            break;
                        default:
                            object = null;
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
         *if (object.id == "box0-0") {
         *    (object as Gtk.Widget).get_style_context ().add_class ("test1");
         *} else if (object.id == "box0-1") {
         *    (object as Gtk.Widget).get_style_context ().add_class ("test2");
         *}
         */

        var type = (object as GLib.Object).get_type ();
        var type_name = type.name ();
        debug ("Packing object of type `%s' into `%s'", type_name, id);

        // FIXME: shouldn't have to do this
        if (object is Dcs.UI.ChannelTreeView) {
            (this as Gtk.Widget).width_request = (object as Gtk.Widget).width_request;
        }

        objects.set (object.id, object);
        // FIXME: could probably just add them all as a Dcs.UI.Widget
        if (object is Dcs.UI.CustomWidget) {
            debug ("Pack custom widget");
            pack_start (object as Dcs.UI.CustomWidget,
                            (object as Gtk.Widget).expand,
                            (object as Dcs.UI.Widget).fill, 0);
        } else if (object is Dcs.UI.CompositeWidget) {
            debug ("Pack composite widget");
            pack_start (object as Dcs.UI.CompositeWidget,
                            (object as Gtk.Widget).expand,
                            (object as Dcs.UI.Widget).fill, 0);
        } else if (object is Dcs.UI.SimpleWidget) {
            debug ("Pack simple widget");
            pack_start (object as Dcs.UI.SimpleWidget,
                            (object as Gtk.Widget).expand,
                            (object as Dcs.UI.Widget).fill, 0);
        }

        /**
         * Without this the scaling of packed widgets doesn't always do what
         * you think it should.
         */
        if (object is Dcs.UI.RichContent) {
            debug ("Pack WebKit widget");
            (parent as Gtk.Container).child_set_property (this as Gtk.Widget, "expand", true);
            child_set_property (object as Gtk.Widget, "expand", true);
        } else if (object is Dcs.UI.Box) {
            debug ("Pack box widget");
            //child_set_property (object as Gtk.Widget, "expand", true);
            child_set_property (object as Gtk.Widget, "fill", true);
        }

        show_all ();
    }

    /**
     * {@inheritDoc}
     */
    public override void update_objects (Gee.Map<string, Dcs.Object> val) {
        _objects = val;
    }
}
