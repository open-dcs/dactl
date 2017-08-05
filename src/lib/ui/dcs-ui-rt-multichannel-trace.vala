/**
 * A chart trace that accesses a channel_vector
 */
public class Dcs.UI.RTMultiChannelTrace : Dcs.UI.Trace, Dcs.Container {

    private Gee.Map<string, Dcs.Object> _objects;
    public Dcs.UI.ChannelVector channel_vector { get; private set; }
    public bool highlight { get; set; default = false; }
    private Dcs.SimplePoint [] points_array;

    /**
     * {@inheritDoc}
     */
    public Gee.Map<string, Dcs.Object> objects {
        get { return _objects; }
        set { update_objects (value); }
    }

    construct {
        objects = new Gee.TreeMap<string, Dcs.Object> ();
    }

    public RTMultiChannelTrace (Xml.Ns* ns,
                    string id,
                    Dcs.UI.TraceDrawType draw_type,
                    int line_weight,
                    Gdk.RGBA color) {

        this.id = id;
        this.draw_type = draw_type;
        this.line_weight = line_weight;
        this.color = color;

        this.config_node = new Xml.Node (ns, id);
        config_node->new_prop ("id", id);
        config_node->new_prop ("type", "trace");
        config_node->new_prop ("ttype", "multichannel");

        Xml.Node* color_node = new Xml.Node (ns, "property");
        color_node->new_prop ("name", "color");
        color_node->add_content (color.to_string ());

        config_node->add_child (color_node);
    }

    /**
     * Construction using an XML node.
     */
    public RTMultiChannelTrace.from_xml_node (Xml.Node *node) {
        base.from_xml_node (node);
        build_from_xml_node (node);
    }

    /**
     * {@inheritDoc}
     */
    internal void build_from_xml_node (Xml.Node *node) {
        if (node->type == Xml.ElementType.ELEMENT_NODE &&
            node->type != Xml.ElementType.COMMENT_NODE) {
            this.config_node = node;
            id = node->get_prop ("id");
            /* Iterate through node children */
            for (Xml.Node *iter = node->children; iter != null; iter = iter->next) {
                if (iter->name == "property") {
                    switch (iter->get_prop ("name")) {
                        /* XXX TBD */
                        /*
                         *case "":
                         *    break;
                         */
                        default:
                            break;
                    }
                } else if (iter->name == "object") {
                    var type = iter->get_prop ("type");
                    if (type == "channel-vector") {
                        channel_vector = new Dcs.UI.ChannelVector.from_xml_node (iter);
                        this.add_child (channel_vector);
                    }
                }
            }
        }
    }

    /**
     * Update the trace raw data
     */
    public void refresh () {
        raw_data = channel_vector.to_array ();
        for (int i = 0; i < raw_data.length; i++) {
            debug ("i: %d x: %.3f y: %.3f", i, raw_data[i].x, raw_data[i].y);
        }
    }

    /**
     * Update the chart data array
     */
    public new void update () {
        /* scale the raw data to non-integer pixel values */
        double[] scaled_xdata = new double[raw_data.length];
        double[] scaled_ydata = new double[raw_data.length];

        for (int i = 0; i < raw_data.length; i++) {
            scaled_xdata[i] = width * (raw_data[i].x - x_min) / (x_max - x_min);
            debug ("i: %d rawx: %.3f scaledx: %.3f w: %d", i, raw_data[i].x, scaled_xdata[i], width);
            scaled_ydata[i] = height * (1 - (raw_data[i].y - y_min) / (y_max - y_min));
        }

        /* Compute new pixel data */
        pixel_data.clear ();
        for (int i = 0; i < raw_data.length; i++) {
            pixel_data.add (new Dcs.Point (scaled_xdata[i], scaled_ydata[i]));
            debug ("i: %d x: %.3f  y: %.3f", i, pixel_data[i].x, pixel_data[i].y);
        }
    }

    /**
     * {@inheritDoc}
     */
    public void update_objects (Gee.Map<string, Dcs.Object> val) {
        _objects = val;
    }
}
