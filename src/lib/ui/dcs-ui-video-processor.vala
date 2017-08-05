[GtkTemplate (ui = "/org/opendcs/libdcs/ui/video-processor.ui")]
public class Dcs.UI.VideoProcessor : Dcs.UI.CompositeWidget, Dcs.CldAdapter {

    [GtkChild]
    private Gtk.Image img_capture;

    private Gee.Map<string, Dcs.Object> _objects;

    //public string ch_ref { get; set; }

    //private weak Cld.Channel _channel;

    //public Cld.Channel channel {
        //get { return _channel; }
        //set {
            //if ((value as Cld.Object).uri == ch_ref) {
                //_channel = value;
                //channel_isset = true;
            //}
        //}
    //}

    //private bool channel_isset { get; private set; default = false; }

    /**
     * {@inheritDoc}
     */
    public override Gee.Map<string, Dcs.Object> objects {
        get { return _objects; }
        set { update_objects (value); }
    }

    /**
     * {@inheritDoc}
     */
    protected bool satisfied { get; set; default = false; }

    construct {
        id = "vid-proc0";

        objects = new Gee.TreeMap<string, Dcs.Object> ();
    }

    public VideoProcessor () {
        //this.ch_ref = ai_ref;

        // Request CLD data
        request_data.begin ();
    }

    public VideoProcessor.from_xml_node (Xml.Node *node) {
        build_from_xml_node (node);

        // Request CLD data
        request_data.begin ();
    }

    /**
     * {@inheritDoc}
     */
    public override void build_from_xml_node (Xml.Node *node) {
        if (node->type == Xml.ElementType.ELEMENT_NODE &&
            node->type != Xml.ElementType.COMMENT_NODE) {
            id = node->get_prop ("id");

        }
    }

    /**
     * {@inheritDoc}
     */
    public void offer_cld_object (Cld.Object object) {
        //if (object.uri == ch_ref) {
            //channel = (object as Cld.Channel);
            //satisfied = true;

            //Timeout.add (1000, update);
            //lbl_tag.label = channel.tag;
        //}
    }

    /**
     * {@inheritDoc}
     */
    protected async void request_data () {
        satisfied = true;
        while (!satisfied) {
            //request_object (ch_ref);
            // Try again in a second
            yield nap (1000);
        }
    }

    /**
     * {@inheritDoc}
     */
    public override void update_objects (Gee.Map<string, Dcs.Object> val) {
        _objects = val;
    }
}
