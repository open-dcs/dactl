public abstract class Dcs.AbstractObject : GLib.Object, Dcs.Object, Dcs.Serializable {

    public string id { get; set; }

    /**
     * {@inheritDoc}
     */
    public virtual string serialize () throws GLib.Error {
        string data = "";

        Xml.Doc *doc = new Xml.Doc ("1.0");
        //Xml.Ns *ns = new Xml.Ns (null, "", "dcs");
        //ns->type = Xml.ElementType.ELEMENT_NODE;
        Xml.Node *node = new Xml.Node (null, "object");
        doc->set_root_element (node);
        Xml.Attr *attr = node->new_prop ("id", id);
        doc->dump_memory (out data);
        /* XXX lame, but node/buffer memory dump methods aren't in the vapi */
        data = data.replace ("<?xml version=\"1.0\"?>\n", "");
        data = data.strip ();

        return data;
    }

    /**
     * {@inheritDoc}
     */
    public virtual void deserialize (string data) throws GLib.Error {
        Xml.Doc *doc = Xml.Parser.parse_memory (data, data.length);
        Xml.XPath.Context *ctx = new Xml.XPath.Context (doc);
        Xml.XPath.Object *obj = ctx->eval_expression ("/object");
        Xml.Node *node = obj->nodesetval->item (0);
        if (node->type == Xml.ElementType.ELEMENT_NODE &&
            node->type != Xml.ElementType.COMMENT_NODE) {
            /* XXX not required for an object, all other derive types declare a type
             *if (node->get_prop ("type") == "object") {
             *} else {
             *    throw new Dcs.SerializationError.INVALID_TYPE ("An invalid type was provided.");
             *}
             */
            string? _id = node->get_prop ("id");
            if (_id != null) {
                id = _id;
            } else {
                throw new Dcs.SerializationError.INVALID_CONTENT ("Invalid XML content was provided.");
            }
        } else {
            throw new Dcs.SerializationError.INVALID_CONTENT ("Invalid XML content was provided.");
        }
    }

    /**
     * {@inheritDoc}
     */
    public virtual Json.Node json_serialize () throws GLib.Error {
        Json.Node node = null;
        return null;
    }

    /**
     * {@inheritDoc}
     */
    public virtual void json_deserialize (Json.Node node) throws GLib.Error {
    }
}
