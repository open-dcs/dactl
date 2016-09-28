[GtkTemplate (ui = "/org/opendcs/dcs/ui/settings-dialog.ui")]
public class Dcsg.SettingsDialog : Gtk.Window {

    [GtkChild]
    private Dcsg.SettingsTopbar settings_topbar;

    [GtkChild]
    private Dcsg.GeneralSettings general;

    [GtkChild]
    private Dcsg.AcquisitionSettings acquisition;

    [GtkChild]
    private Dcsg.ControlSettings control;

    [GtkChild]
    private Dcsg.LogSettings log;

    [GtkChild]
    private Dcsg.PluginSettings plugin;

    [GtkChild]
    private Dcsg.WidgetSettings widget;

    private Cld.Context cld_ctx;

    private Dcs.ApplicationModel model;

    private Dcsg.CldSettingsData cld_data;

    private Dcsg.NativeSettingsData dcs_data;

    construct {
        /* Build data objects for CLD and Dcs (ie. native) namespaces */
        model = Dcsg.Application.get_default ().model;
        cld_ctx = model.ctx;

        /* Configurable CLD data */
        cld_data = new Dcsg.CldSettingsData.from_object (cld_ctx);
        Gee.ArrayList<Dcsg.CldSettingsData> cld_list = new Gee.ArrayList<Dcsg.CldSettingsData> ();
        cld_list.add (acquisition.data);
        cld_list.add (control.data);
        cld_list.add (log.data);

        /* Update the data object when a value changes */
        foreach (var page_data in cld_list) {
            page_data.new_data.connect ((source, uri, spec, value) => {
                cld_data.uri_selected = uri;
                cld_data.set_value (spec, value);
            });
        }

        /* Configurable DCS data */
        dcs_data = new Dcsg.NativeSettingsData.from_map (model.objects);
        Gee.ArrayList<Dcsg.NativeSettingsData> dcs_list = new Gee.ArrayList<Dcsg.NativeSettingsData> ();
        dcs_list.add (widget.data);

        /* Update the data object when a value changes */
        foreach (var page_data in dcs_list) {
            page_data.new_data.connect ((source, object, spec, value) => {
                dcs_data.object_selected = object;
                dcs_data.set_value (spec, value);
            });
        }

        settings_topbar.ok.connect (ok);
        settings_topbar.cancel.connect (cancel);
    }

    private void ok () {
        /* Copy settings values to objects in the Cld context */
        foreach (var uri in cld_data.keys) {
            var object = cld_ctx.get_object_from_uri (uri);
            if (object != null) {
                var svalues = cld_data.get (uri);
                foreach (var spec in svalues.keys) {
                    if (spec.owner_type.name ().contains ("Cld")) {
                        var name = spec.get_name ();
                        var value = svalues.get (spec).value;
                        bool writable = (spec.flags & GLib.ParamFlags.WRITABLE) ==
                                                        GLib.ParamFlags.WRITABLE;
                        bool is_cld_object = value.type ().is_a (Type.from_name ("CldObject"));
                        if (writable && !is_cld_object) {
                            debug (
                                "%s:%s  %s:%s",
                                uri,
                                object.get_type ().name (),
                                name,
                                value.type ().name ()
                                );
                            object.set_property (name, value);
                        } else if (!writable) {
                            debug (
                                "%s:%s  %s:%s is not writable",
                                uri,
                                object.get_type ().name (),
                                name,
                                value.type ().name ()
                                );
                        } else if (writable && is_cld_object) {
                            object.set_object_property (name, (Cld.Object)value);
                        }
                    }
                }
            }
        }

        /* Copy dcs settings to objects in the UI model */
        foreach (var object in dcs_data.keys) {
            debug ("%s", object.id);
            if (object != null) {
                var svalues = dcs_data.get (object);
                foreach (var spec in svalues.keys) {
                    if (spec.owner_type.name ().contains ("Dcs")) {
                        var name = spec.get_name ();
                        var value = svalues.get (spec).value;
                        bool writable = (spec.flags & GLib.ParamFlags.WRITABLE) ==
                                                        GLib.ParamFlags.WRITABLE;
                        bool is_dcs_object = value.type ().is_a (Type.from_name ("DcsObject"));
                        bool is_cld_object = value.type ().is_a (Type.from_name ("CldObject"));
                        if (writable && !is_dcs_object && !is_cld_object) {
                            debug (
                                "%s:%s  %s:%s",
                                object.id,
                                object.get_type ().name (),
                                name,
                                value.type ().name ()
                                );
                            /* FIXME use reparent if property is Gtk.Widget.parent */
                            /*
                            *if ((object.get_type ()).is_a (typeof (Gtk.Widget))) {
                            *    if (name == "parent") {
                            *        (object as Gtk.Widget).reparent (value as Gtk.Container);
                            *        message ("object is %s with %s that is %s", object.get_type ().name (), name, value.type_name ());
                            *    }
                            *} else {
                            */
                                object.set_property (name, value);
                                debug ("id: %s prop name: %s", object.id, name);
                            /*
                            *}
                            */
                        } else if (!writable) {
                            debug (
                                "%s:%s  %s:%s is not writable",
                                object.id,
                                object.get_type ().name (),
                                name,
                                value.type ().name ()
                                );
                        } else if (writable && is_dcs_object) {
                            /* XXX FIXME This doesn't do anything yet */
                            /*object.set_object_property (name, (Dcs.Object)value);*/
                        } else if (writable && is_cld_object) {
                            /* XXX FIXME This doesn't do anything yet */
                            /*object.set_object_property (name, (Cld.Object)value);*/
                        }
                    }
                }
            }
        }

        general.update_preferences ();

        destroy ();
    }

    private void cancel () {
        close ();
    }
}

