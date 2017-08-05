public errordomain Dcs.BuildableError {
    INVALID_BUILD,
}

/**
 * A common interface for buildable objects.
 *
 * TODO Refactor this class out, it doesn't do anything.
 */
public interface Dcs.Buildable : GLib.Object {

    protected abstract Xml.Node* config_node { get; set; }

    public static unowned string get_xml_default () {
        return "<object type=\"buildable\"/>";
    }

    public static unowned string get_xsd_default () {
        return """
          <xs:element name="object">
            <xs:attribute name="id" type="xs:string" use="required"/>
            <xs:attribute name="type" type="xs:string" use="required"/>
          </xs:element>
        """;
    }

    /**
     * Build the object using an XML node
     *
     * @param node XML node to construction the object from
     */
    internal abstract void build_from_xml_node (Xml.Node* node)
                                                throws GLib.Error;
}
