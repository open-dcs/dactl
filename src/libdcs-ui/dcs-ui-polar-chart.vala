[GtkTemplate (ui = "/org/coanda/libdcs-ui/ui/polar-chart.ui")]
public class Dcs.UI.PolarChart : Dcs.UI.CompositeWidget {

    private int _refresh_ms = 33;
    private uint timer_id;
    /**
     * The time period that is the inverse of the refresh rate
     */
    public int refresh_ms {
        get { return _refresh_ms; }
        set { _refresh_ms = value; }
    }

    private Xml.Node* _node;

    private string _xml = """
        <ui:object id=\"chart0\" type=\"polar-chart\"/>
          <ui:property name=\"title\">Chart 0</ui:property>
          <ui:property name=\"height-min\">100</ui:property>
          <ui:property name=\"width-min\">100</ui:property>
          <ui:property name=\"expand\">true</ui:property>
          <ui:property name=\"fill\">true</ui:property>
          <ui:property name=\"show-title\">true</ui:property>
          <ui:property name=\"show-grid\">true</ui:property>
          <ui:property name=\"show-grid-border\">true</ui:property>
    """;

    private string _xsd = """
        <xs:element name="object">
          <xs:attribute name="id" type="xs:string" use="required"/>
          <xs:attribute name="type" type="xs:string" use="required"/>
          <xs:attribute name="ref" type="xs:string" use="required"/>
        </xs:element>
    """;

    private Gee.Map<string, Dcs.Object> _objects;

    /**
     * {@inheritDoc}
     */
    protected override string xml {
        get { return _xml; }
    }

    /**
     * {@inheritDoc}
     */
    protected override string xsd {
        get { return _xsd; }
    }

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
    protected virtual Xml.Node* node {
        get {
            return _node;
        }
        set {
            _node = value;
        }
    }

    /**
     * {@inheritDoc}
     */
    protected bool satisfied { get; set; default = false; }

    /* Title */
    public string title { get; set; default = "Chart"; }

    /* Minimum height to support scrollable container */
    public int height_min { get; set; default = 100; }

    /* Minimum width to support scrollable container */
    public int width_min { get; set; default = 100; }

    private double _zoom;
    public double zoom {
        get { return _zoom; }
        set {
            _zoom = value;
            canvas.zoom = value;
        }
        default = 0.8;
    }

    public Dcs.UI.ChartFlag flags { get; set; }

    protected Dcs.UI.PolarAxis mag_axis;

    protected Dcs.UI.PolarAxis angle_axis;

    [GtkChild]
    private Gtk.Grid grid;

    [GtkChild]
    protected Dcs.UI.PolarChartCanvas canvas;

    [GtkChild]
    protected Gtk.Label lbl_title;

    [GtkChild]
    protected Gtk.Label lbl_c_axis;

    [GtkChild]
    protected Gtk.Label lbl_x_axis;

    private Gee.Map<string, Dcs.Object> drawables;

	private Dcs.UI.ColorMap colormap = null;

    /**
     * Common object construction.
     */
    construct {
        id = "chart0";
        canvas.id = "%s-canvas0".printf (id);
        objects = new Gee.TreeMap<string, Dcs.Object> ();
        hexpand = true;
        vexpand = true;
        halign = Gtk.Align.FILL;
        valign = Gtk.Align.FILL;
        flags = Dcs.UI.ChartFlag.DRAW_TITLE | Dcs.UI.ChartFlag.DRAW_GRID;

        connect_signals ();
    }

    /**
     * Construction using an XML node.
     */
    public PolarChart.from_xml_node (Xml.Node *node) {
        build_from_xml_node (node);
        canvas.id = "%s-canvas0".printf (id);
        update_layout ();

        drawables = get_object_map (typeof (Dcs.UI.Drawable));
        foreach (var drawable in drawables.values) {
            if (drawable is Dcs.UI.PolarHeatMap) {
                var binding = bind_property ("zoom", drawable as Dcs.UI.PolarHeatMap,
                                             "zoom", GLib.BindingFlags.DEFAULT);
                (drawable as Dcs.UI.PolarHeatMap).zoom = zoom;
            }
        }
        do_flags ();
        connect_notify_signals ();
        start_timer ();
        show_all ();
    }

    /**
     * {@inheritDoc}
     */
    public override void build_from_xml_node (Xml.Node *node) {
        string? value;

        this.node = node;
        if (node->type == Xml.ElementType.ELEMENT_NODE &&
            node->type != Xml.ElementType.COMMENT_NODE) {
            id = node->get_prop ("id");

            /* Iterate through node children */
            for (Xml.Node *iter = node->children; iter != null; iter = iter->next) {
                if (iter->name == "property") {

                    switch (iter->get_prop ("name")) {
                        case "title":
                            title = iter->get_content ();
                            lbl_title.set_text (title);
                            break;
                        case "expand":
                            value = iter->get_content ();
                            expand = bool.parse (value);
                            break;
                        case "fill":
                            value = iter->get_content ();
                            fill = bool.parse (value);
                            break;
                        case "height-min":
                            value = iter->get_content ();
                            height_min = int.parse (value);
                            break;
                        case "width-min":
                            value = iter->get_content ();
                            width_min = int.parse (value);
                            break;
                        case "refresh-ms":
                            value = iter->get_content ();
                            refresh_ms = int.parse (value);
                            break;
                        case "zoom":
                            value = iter->get_content ();
                            zoom = double.parse (value);
                            break;
                        case "show-title":
                            value = iter->get_content ();
                            if (bool.parse (value))
                                flags = flags.set (Dcs.UI.ChartFlag.DRAW_TITLE);
                            else
                                flags = flags.unset (Dcs.UI.ChartFlag.DRAW_TITLE);
                            break;
                        case "show-grid":
                            value = iter->get_content ();
                            if (bool.parse (value))
                                flags = flags.set (Dcs.UI.ChartFlag.DRAW_GRID);
                            else
                                flags = flags.unset (Dcs.UI.ChartFlag.DRAW_GRID);
                            break;
                        case "show-grid-border":
                            value = iter->get_content ();
                            if (bool.parse (value))
                                flags = flags.set (Dcs.UI.ChartFlag.DRAW_GRID_BORDER);
                            else
                                flags = flags.unset (Dcs.UI.ChartFlag.DRAW_GRID_BORDER);
                            break;
                        default:
                            break;
                    }
                } else if (iter->name == "object") {
                    var type = iter->get_prop ("type");
                    if (type == "polar-chart-axis") {
                        var axis = new Dcs.UI.PolarAxis.from_xml_node (iter);
                        this.add_child (axis);
                    } else if (type == "trace") {
                        /*
                         *var subtypetype = iter->get_prop ("subtype");
                         *if (ttype == "r-theta") {
                         *    var trace = new Dcs.UI.Trace.from_xml_node (iter);
                         *    this.add_child (trace);
                         *} else if (ttype == "real-time") {
                         *    var trace = new Dcs.UI.RTTrace.from_xml_node (iter);
                         *    this.add_child (trace);
                         *} else if (ttype == "multichannel") {
                         *    var trace = new Dcs.UI.RTMultiChannelTrace.from_xml_node (iter);
                         *    this.add_child (trace);
                         *}
                         */
                    } else if (type == "heatmap") {
                        var heatmap = new Dcs.UI.PolarHeatMap.from_xml_node (iter);
                        this.add_child (heatmap);
                    } else if (type == "colormap") {
                        var colormap = new Dcs.UI.ColorMap.from_xml_node (iter);
                        this.add_child (colormap);
                    }
                }
            }
        }
    }

    private void start_timer () {
        var drawables = get_object_map (typeof (Dcs.UI.Drawable));

        if (timer_id != 0)
            GLib.Source.remove (timer_id);
        timer_id = GLib.Timeout.add (refresh_ms, () => {
            /* XXX This is ugly */
            foreach (var drawable in drawables.values) {
                if (drawable is Dcs.UI.PolarHeatMap)
                    (drawable as Dcs.UI.PolarHeatMap).refresh ();
            }
            canvas.redraw ();

            return GLib.Source.CONTINUE;
        }, GLib.Priority.DEFAULT);
    }

    /**
     * Connect all notify signals to update node
     */
    private void connect_notify_signals () {
        Type type = get_type ();
        ObjectClass ocl = (ObjectClass)type.class_ref ();

        foreach (ParamSpec spec in ocl.list_properties ()) {
            notify[spec.get_name ()].connect ((s, p) => {
                update_node ();
                queue_draw ();
            });
        }

        notify["title"].connect (() => {
            lbl_title.set_text (title);
        });

        notify["flags"].connect ((s, p) => {
            do_flags ();
        });

        notify["refresh-ms"].connect (() => {
            start_timer ();
        });
    }

    private void do_flags () {
        if (flags.is_set (Dcs.UI.ChartFlag.DRAW_TITLE)) {
            var parent = lbl_title.get_parent ();
            parent.remove (lbl_title);
            if (lbl_title.parent == null) {
                (grid as Gtk.Grid).attach (lbl_title, 0, 0, 2, 1);
            }
        } else {
            var parent = lbl_title.get_parent ();
            parent.remove (lbl_title);
        }

        flags.is_set (Dcs.UI.ChartFlag.DRAW_GRID)
        ? canvas.draw_grid = true : canvas.draw_grid = false;

        flags.is_set (Dcs.UI.ChartFlag.DRAW_GRID_BORDER)
        ? canvas.draw_grid_border = true : canvas.draw_grid_border = false;

        canvas.redraw ();
    }

    /**
     * Update the XML Node for this object.
     */
    private void update_node () {
        if (node->type == Xml.ElementType.ELEMENT_NODE &&
            node->type != Xml.ElementType.COMMENT_NODE) {
            /* iterate through node children */
            for (Xml.Node *iter = node->children;
                 iter != null;
                 iter = iter->next) {
                if (iter->name == "property") {
                    switch (iter->get_prop ("name")) {
                        case "title":
                            iter->set_content (title);
                            break;
                        case "expand":
                            iter->set_content (expand.to_string ());
                            break;
                        case "fill":
                            iter->set_content (fill.to_string ());
                            break;
                        case "height-min":
                            iter->set_content ("%d".printf (height_min));
                            break;
                        case "width-min":
                            iter->set_content ("%d".printf (width_min));
                            break;
                        case "refresh-ms":
                            iter->set_content ("%d".printf (refresh_ms));
                            break;
                        case "zoom":
                            iter->set_content ("%0.3f".printf (zoom));
                            break;
                        case "show-title":
                            iter->set_content (flags.is_set (Dcs.UI.ChartFlag.DRAW_TITLE).to_string ());
                            break;
                        case "show-grid":
                            iter->set_content (flags.is_set (Dcs.UI.ChartFlag.DRAW_GRID).to_string ());
                            break;
                        case "show-grid-border":
                            iter->set_content (flags.is_set (Dcs.UI.ChartFlag.DRAW_GRID_BORDER).to_string ());
                            break;
                        case "reverse-x-axis":
                            iter->set_content (flags.is_set (Dcs.UI.ChartFlag.REVERSE_X_AXIS).to_string ());
                            break;
                        case "show-x-axis-label":
                            iter->set_content (flags.is_set (Dcs.UI.ChartFlag.DRAW_X_AXIS_LABEL).to_string ());
                            break;
                        case "rotate-x-axis-label":
                            iter->set_content (flags.is_set (Dcs.UI.ChartFlag.ROTATE_X_AXIS_LABEL).to_string ());
                            break;
                        case "show-y-axis-label":
                            iter->set_content (flags.is_set (Dcs.UI.ChartFlag.DRAW_Y_AXIS_LABEL).to_string ());
                            break;
                        case "rotate-y-axis-label":
                            iter->set_content (flags.is_set (Dcs.UI.ChartFlag.ROTATE_Y_AXIS_LABEL).to_string ());
                            break;
                        default:
                            break;
                    }
                }
            }
        }
    }

    private void update_layout () {
        var axes = get_object_map (typeof (Dcs.UI.PolarAxis));

        foreach (var axis in axes.values) {
            if ((axis as Dcs.UI.PolarAxis).axis_type ==
                                                Dcs.UI.PolarAxisType.MAGNITUDE) {
                mag_axis = axis as Dcs.UI.PolarAxis;
                canvas.mag_axis = mag_axis;
            } else if ((axis as Dcs.UI.PolarAxis).axis_type ==
                                                     Dcs.UI.PolarAxisType.ANGLE){
                angle_axis = axis as Dcs.UI.PolarAxis;
                canvas.angle_axis = angle_axis;
            }
        }

        var colormaps = get_object_map (typeof (Dcs.UI.ColorMap));

        foreach (var map in colormaps.values) {
            /* there should only be one */
            grid.attach (map as Dcs.UI.ColorMap, 1, 1, 1, 1);
			colormap = map as Dcs.UI.ColorMap;
        }

        update_heatmaps ();
    }

    /**
     * Connect any signals including the notifications from the model.
     */
    private void connect_signals () {
        /*Draw everything else after the default handler has run*/
        canvas.draw.connect_after (draw_more);
    }

    private bool draw_more (Gtk.Widget da, Cairo.Context cr) {
        double x_max, x_min, y_max, y_min;
        var w = canvas.get_allocated_width ();
        var h = canvas.get_allocated_height ();
        var mag_min = mag_axis.min;
        var mag_max = mag_axis.max;
        var angle_min = angle_axis.min;
        var angle_max = angle_axis.max;
        /* XXX can image surface set be put in Dcs.UI.Drawable as virtual */
        var image_surface = new Cairo.ImageSurface (Cairo.Format.ARGB32, w, h);

        canvas.grid.limits (mag_axis, angle_axis, w, h,
                                       out x_max, out x_min,
                                       out y_max, out y_min);
        foreach (var drawable in drawables.values) {
            (drawable as Dcs.UI.Drawable).image_surface = image_surface;
            (drawable as Dcs.UI.Drawable).generate (w, h, x_min, x_max,
                                                          y_min, y_max);
            (drawable as Dcs.UI.Drawable).draw (cr); // XXX put this in drawable too?
        }

        update_heatmaps ();

        return false;
    }

    private void update_heatmaps () {
        var heatmaps = get_object_map (typeof (Dcs.UI.PolarHeatMap));
        foreach (var map in heatmaps.values) {
			if (colormap != null) {
                (map as Dcs.UI.PolarHeatMap).max_color = colormap.max_color;
				(map as Dcs.UI.PolarHeatMap).min_color = colormap.min_color;
				(map as Dcs.UI.PolarHeatMap).gradient = colormap.gradient;
                (map as Dcs.UI.PolarHeatMap).zmax = colormap.max;
				(map as Dcs.UI.PolarHeatMap).zmin = colormap.min;
			}
        }
    }

    /**
     * {@inheritDoc}
     */
    public override void update_objects (Gee.Map<string, Dcs.Object> val) {
        _objects = val;
    }
}
