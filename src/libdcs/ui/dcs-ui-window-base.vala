/**
 * Window base class to use with buildable child windows.
 */
public abstract class Dcs.UI.WindowBase : Gtk.ApplicationWindow, Dcs.View, Dcs.Container, Dcs.Buildable, Dcs.Object {

    private Xml.Node* _config_node;

    /**
     * {@inheritDoc}
     */
    public virtual string id { get; set; }

    /**
     * {@inheritDoc}
     */
    protected virtual Xml.Node* config_node {
        get {
            return _config_node;
        }
        set {
            _config_node = value;
        }
    }

    public bool fullscreen { get; set; default = false; }

    /**
     * Current window state
     */
    public Dcs.UI.WindowState state { get; set; default = Dcs.UI.WindowState.WINDOWED; }

    /**
     * {@inheritDoc}
     */
    public abstract Gee.Map<string, Dcs.Object> objects { get; set; }

    /**
     * {@inheritDoc}
     */
    public abstract void build_from_xml_node (Xml.Node *node);

    /**
     * {@inheritDoc}
     */
    public abstract void update_objects (Gee.Map<string, Dcs.Object> val);

    /**
     * {@inheritDoc}
     */
    public virtual void add (owned Dcs.Object object, string path)
                             throws GLib.Error {
        throw new Dcs.ViewError.INVALID_VIEW_REQUEST ("Add method was not added.");
    }

    /**
     * Generic UI object request method.
     */
    public void request (Dcs.UI.WindowRequest request, Dcs.Object object, Dcs.Object parent) {
        switch (request) {
            case Dcs.UI.WindowRequest.ADD:
                break;
            case Dcs.UI.WindowRequest.REMOVE:
                break;
            case Dcs.UI.WindowRequest.HIDE:
                break;
            case Dcs.UI.WindowRequest.SHOW:
                break;
            default:
                break;
        }
    }
}
