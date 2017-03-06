public abstract class Dcs.AbstractBuildable : Dcs.AbstractObject, Dcs.Buildable {

    //protected abstract Dcs.ConfigNode node { get; set; }

    protected Xml.Node* node { get; set; }

    /**
     * {@inheritDoc}
     */
    internal virtual void build_from_xml_node (Xml.Node* node)
                                               throws GLib.Error {
        throw new Dcs.BuildableError.INVALID_BUILD ("No build was provided");
    }
}
