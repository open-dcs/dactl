public abstract class Dcs.UI.Application : Gtk.Application, Dcs.Application {

    /**
     * {@inheritDoc}
     */
    public Dcs.Model model { get; set; }

    /**
     * {@inheritDoc}
     */
    public Dcs.View view { get; set; }

    /**
     * {@inheritDoc}
     */
    public Dcs.Controller controller { get; set; }

    /**
     * {@inheritDoc}
     */
    public Gee.ArrayList<Dcs.LegacyPlugin> plugins { get; set; }

    /**
     * {@inheritDoc}
     */
    public virtual int launch (string[] args) {
        return (this as Gtk.Application).run (args);
    }

    /**
     * {@inheritDoc}
     */
    public virtual void register_plugin (Dcs.LegacyPlugin plugin) {
        if (plugin.has_factory) {
            /*Dcs.Object control;*/

            /* Get the node to use from the configuration */
            try {
                string name = plugin.name;
                var xpath = @"//plugin[@type=\"$name\"]";

                debug ("Searching for the node at: %s", xpath);
                Xml.Node *node = model.config.get_xml_node (xpath);
                if (node != null) {
                    /* Iterate through node children */
                    for (Xml.Node *iter = node->children; iter != null; iter = iter->next) {
                        if (iter->name == "object") {
                            var control = plugin.factory.make_object_from_node (iter);
                            model.add_child (control);

                            debug ("Connecting plugin control to CLD data for `%s'", plugin.name);
                            (control as Dcs.CldAdapter).request_object.connect ((uri) => {
                                var object = model.ctx.get_object_from_uri (uri);
                                debug ("Offering object `%s' to `%s'",
                                            object.id, (control as Dcs.Object).id);
                                (control as Dcs.CldAdapter).offer_cld_object (object);
                            });

                            debug ("Attempting to add the plugin control to the layout");
                            var parent = model.get_object ((control as Dcs.UI.PluginControl).parent_ref);
                            (parent as Dcs.UI.Box).add_child (control);
                        }
                    }
                }
            } catch (GLib.Error e) {
                GLib.error (e.message);
            }
        }
	}
}
