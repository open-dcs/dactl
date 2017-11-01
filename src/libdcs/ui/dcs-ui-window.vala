public enum Dcs.UI.WindowState {
    WINDOWED,
    FULLSCREEN
}

public enum Dcs.UI.WindowRequest {
    ADD,
    REMOVE,
    HIDE,
    SHOW
}

[GtkTemplate (ui = "/org/opendcs/libdcs/ui/window.ui")]
public class Dcs.UI.Window : Dcs.UI.WindowBase {

    public int index { get; set; default = 0; }

    /**
     * {@inheritDoc}
     */
    private Gee.Map<string, Dcs.Object> _objects;
    public override Gee.Map<string, Dcs.Object> objects {
        get { return _objects; }
        set { update_objects (value); }
    }

    private string[] pages = { };

    [GtkChild]
    private Gtk.Stack layout;

    /**
     * Common object construction.
     */
    construct {
        id = "win0";
        name = id;
        objects = new Gee.TreeMap<string, Dcs.Object> ();

        set_default_size (1280, 720);
        /*
         *load_style ();
         */
    }

    /**
     * Default construction.
     */
    public Window () {
        GLib.Object (title: "DCS HMI - Child Window",
                     window_position: Gtk.WindowPosition.CENTER);
    }

    /**
     * Construction using an XML node.
     */
    public Window.from_xml_node (Xml.Node *node) {
        GLib.Object (title: "DCS HMI - Child Window",
                     window_position: Gtk.WindowPosition.CENTER);

        build_from_xml_node (node);
    }

    /**
     * {@inheritDoc}
     */
    public override void build_from_xml_node (Xml.Node *node) {
        string? value;
        string type;

        if (node->type == Xml.ElementType.ELEMENT_NODE &&
            node->type != Xml.ElementType.COMMENT_NODE) {
            name = id = node->get_prop ("id");

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
                        case "page":
                            object = new Dcs.UI.Page.from_xml_node (iter);
                            break;
                    }

                    /* no point adding an object type that isn't recognized */
                    if (object != null) {
                        message ("Loading object of type `%s' with id `%s'", type, object.id);
                        add_child (object);
                    }
                }
            }
        }
    }

    /**
     * Load the application styling from CSS.
     */
    /*
     *private void load_style () {
     *    [> Apply stylings from CSS resource <]
     *    var provider = Dcs.load_css ("theme/shared.css");
     *    Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (),
     *                                              provider,
     *                                              600);
     *}
     */

    public void add_actions () {
        var fullscreen_action = new SimpleAction ("fullscreen", null);
        fullscreen_action.activate.connect (fullscreen_action_activated_cb);
        this.add_action (fullscreen_action);
    }

    public void add_page (Dcs.UI.Page page) {
        debug ("Adding page `%s' with title `%s'", page.id, page.title);
        layout.add_titled (page, page.id, page.title);
        pages += page.id;

        // XXX not sure what to do here, needs to do it otherwise won't be configurable
        //model.add_child (page);
    }

    public void add_child (Dcs.Object object) {
        (base as Dcs.Container).add_child (object);
        debug ("Attempting to add widget `%s' to window `%s'", object.id, id);
        if (object is Dcs.UI.Page) {
            add_page (object as Dcs.UI.Page);
        } else {
            warning ("Windows can only add pages for now");
        }
    }

    /**
     * {@inheritDoc}
     */
    public override void update_objects (Gee.Map<string, Dcs.Object> val) {
        _objects = val;
    }

    /**
     * {@inheritDoc}
     */
    /*
     *protected void update_node () { }
     */

    /**
     * Action callback to set fullscreen window mode.
     */
    private void fullscreen_action_activated_cb (SimpleAction action, Variant? parameter) {
        if (state == Dcs.UI.WindowState.WINDOWED) {
            (this as Gtk.Window).fullscreen ();
            state = Dcs.UI.WindowState.FULLSCREEN;
            fullscreen = true;
        } else {
            (this as Gtk.Window).unfullscreen ();
            state = Dcs.UI.WindowState.WINDOWED;
            fullscreen = false;
        }
    }

    [GtkCallback]
    private bool configure_event_cb () {
        return false;
    }

    [GtkCallback]
    private bool delete_event_cb () {
        return false;
    }

    [GtkCallback]
    private bool key_press_event_cb () {
        return false;
    }

    [GtkCallback]
    private bool window_state_event_cb (Gdk.EventWindowState event) {
        if (Dcs.UI.WindowState.FULLSCREEN in event.changed_mask)
            this.notify_property ("fullscreen");

        if (state == Dcs.UI.WindowState.FULLSCREEN)
            return false;

        return false;
    }
}
