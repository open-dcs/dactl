public abstract class Dcs.UI.FooObject : GLib.Object,
                                         Dcs.Object,
                                         Dcs.Buildable,
                                         Dcs.Container {

    public virtual string id { get; set; }

    protected virtual Xml.Node* config_node { get; set; }

    public virtual Gee.Map<string, Dcs.Object> objects { get; set; }

    public virtual Dcs.UI.FooWidget widget { get; protected set; }

    //public abstract FooObject.from_json (Json.Node node);

    public FooObject.from_xml_node (Xml.Node* node) {
        try {
            build_from_xml_node (node);
        } catch (GLib.Error e) {
            debug (e.message);
        }
    }

    internal abstract void build_from_xml_node (Xml.Node* node)
                                                throws GLib.Error;

    /* Srsly need to deprecate */
    protected virtual void update_objects (Gee.Map<string, Dcs.Object> val) {
        objects = val;
    }
}
