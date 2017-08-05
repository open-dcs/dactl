public abstract class Dcs.UI.WebKitWidget : WebKit.WebView, Dcs.UI.Widget, Dcs.Container, Dcs.Buildable, Dcs.Object {

    private Xml.Node* _config_node;

    /**
     * {@inheritDoc}
     */
    public virtual string id { get; set; }

    public bool fill { get; set; default = true; }

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
}
