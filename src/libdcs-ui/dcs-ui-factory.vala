/**
 * Class use to build objects from configuration data.
 */
public class Dcs.UI.Factory : GLib.Object, Dcs.Factory {

    /* Factory singleton */
    private static Dcs.UI.Factory factory;

    public static Dcs.UI.Factory get_default () {
        if (factory == null) {
            factory = new Dcs.UI.Factory ();
        }

        return factory;
    }

    /**
     * {@inheritDoc}
     */
    public Gee.TreeMap<string, Dcs.Object> make_object_map (Xml.Node *node) {
        var objects = new Gee.TreeMap<string, Dcs.Object> ();
        for (Xml.Node *iter = node; iter != null; iter = iter->next) {
            try {
                Dcs.Object object = make_object_from_node (iter);

                /* XXX is this check necessary with the exception? */
                if (object != null) {
                    objects.set (object.id, object);
                    message ("Loading object of type `%s' with id `%s'",
                             iter->get_prop ("type"), object.id);
                }
            } catch (GLib.Error e) {
                critical (e.message);
            }
        }
        build_complete ();

        return objects;
    }

    /**
     * {@inheritDoc}
     */
    public Dcs.Object make_object (Type type)
                                     throws GLib.Error {
        Dcs.Object object = null;

        switch (type.name ()) {
            case "DcsUIAIControl":              break;
            case "DcsUIAOControl":              break;
            case "DcsUIAxis":                   break;
            case "DcsUIBox":                    break;
            case "DcsUIChart":                  break;
            case "DcsUIExec":                   break;
            case "DcsUILogControl":             break;
            case "DcsUIPage":                   break;
            case "DcsUIPid":                    break;
            case "DcsUIPnid":                   break;
            case "DcsUIPnidElement":            break;
            case "DcsUIPolarChart":             break;
            case "DcsUIRTChart":                break;
            case "DcsUIStripChart":             break;
            case "DcsUIStripChartTrace":        break;
            case "DcsUITrace":                  break;
            case "DcsUIChannelTreeView":        break;
            case "DcsUIChannelTreeCategory":    break;
            case "DcsUIChannelTreeEntry":       break;
            case "DcsUIVideoProcessor":         break;
            case "DcsUIRichContent":            break;
            case "DcsUIWindow":                 break;
            default:
                throw new Dcs.FactoryError.TYPE_NOT_FOUND (
                    _("The type requested is not a known Dcs type"));
        }

        return object;
    }

    /**
     * {@inheritDoc}
     */
    public Dcs.Object make_object_from_node (Xml.Node *node)
                                               throws GLib.Error {
        Dcs.Object object = null;

        if (node->type == Xml.ElementType.ELEMENT_NODE &&
            node->type != Xml.ElementType.COMMENT_NODE) {
            if (node->name == "object") {
                var type = node->get_prop ("type");
                switch (type) {
                    case "ai":                  return make_ai (node);
                    case "ao":                  return make_ao (node);
                    case "axis":                return make_axis (node);
                    case "box":                 return make_box (node);
                    case "chart":               return make_chart (node);
                    case "exec":                return make_exec (node);
                    case "log":                 return make_log (node);
                    case "page":                return make_page (node);
                    case "pid":                 return make_pid (node);
                    case "pnid":                return make_pnid (node);
                    case "pnid-element":        return make_pnid_element (node);
                    case "polar-chart":         return make_polar_chart (node);
                    case "rt-chart":            return make_rt_chart (node);
                    case "stripchart":          return make_stripchart (node);
                    case "stripchart-trace":    return make_stripchart_trace (node);
                    case "trace":               return make_trace (node);
                    case "tree":                return make_tree (node);
                    case "tree-category":       return make_tree_category (node);
                    case "tree-entry":          return make_tree_entry (node);
                    case "video":               return make_video_processor (node);
                    case "rich-content":        return make_rich_content (node);
                    case "window":              return make_window (node);
                    default:
                        throw new Dcs.FactoryError.TYPE_NOT_FOUND (
                            _("The type requested is not a known Dcs type"));
                }
            }
        }

        return object;
    }

    /**
     * XXX not really sure about whether or not this should let the objects
     *     construct themselves or if the actual property assignment should
     *     happen here
     */

    private Dcs.Object make_ai (Xml.Node *node) {
        return new Dcs.UI.AIControl.from_xml_node (node);
    }

    private Dcs.Object make_ao (Xml.Node *node) {
        return new Dcs.UI.AOControl.from_xml_node (node);
    }

    private Dcs.Object make_axis (Xml.Node *node) {
        return new Dcs.UI.Axis.from_xml_node (node);
    }

    private Dcs.Object make_box (Xml.Node *node) {
        return new Dcs.UI.Box.from_xml_node (node);
    }

    private Dcs.Object make_chart (Xml.Node *node) {
        return new Dcs.UI.Chart.from_xml_node (node);
    }

    private Dcs.Object make_exec (Xml.Node *node) {
        return new Dcs.UI.ExecControl.from_xml_node (node);
    }

    private Dcs.Object make_log (Xml.Node *node) {
        return new Dcs.UI.LogControl.from_xml_node (node);
    }

    private Dcs.Object make_page (Xml.Node *node) {
        return new Dcs.UI.Page.from_xml_node (node);
    }

    private Dcs.Object make_pid (Xml.Node *node) {
        return new Dcs.UI.PidControl.from_xml_node (node);
    }

    private Dcs.Object make_pnid (Xml.Node *node) {
        return new Dcs.UI.Pnid.from_xml_node (node);
    }

    private Dcs.Object make_pnid_element (Xml.Node *node) {
        return new Dcs.UI.PnidElement.from_xml_node (node);
    }

    private Dcs.Object make_polar_chart (Xml.Node *node) {
        return new Dcs.UI.PolarChart.from_xml_node (node);
    }

    private Dcs.Object make_rich_content (Xml.Node *node) {
        return new Dcs.UI.RichContent.from_xml_node (node);
    }

    private Dcs.Object make_rt_chart (Xml.Node *node) {
        return new Dcs.UI.RTChart.from_xml_node (node);
    }

    private Dcs.Object make_stripchart (Xml.Node *node) {
        return new Dcs.UI.StripChart.from_xml_node (node);
    }

    private Dcs.Object make_stripchart_trace (Xml.Node *node) {
        return new Dcs.UI.StripChartTrace.from_xml_node (node);
    }

    private Dcs.Object make_trace (Xml.Node *node) {
        return new Dcs.UI.Trace.from_xml_node (node);
    }

    private Dcs.Object make_tree (Xml.Node *node) {
        return new Dcs.UI.ChannelTreeView.from_xml_node (node);
    }

    private Dcs.Object make_tree_category (Xml.Node *node) {
        return new Dcs.UI.ChannelTreeCategory.from_xml_node (node);
    }

    private Dcs.Object make_tree_entry (Xml.Node *node) {
        return new Dcs.UI.ChannelTreeEntry.from_xml_node (node);
    }

    private Dcs.Object make_video_processor (Xml.Node *node) {
        return new Dcs.UI.VideoProcessor.from_xml_node (node);
    }

    private Dcs.Object make_window (Xml.Node *node) {
        return new Dcs.UI.Window.from_xml_node (node);
    }
}
