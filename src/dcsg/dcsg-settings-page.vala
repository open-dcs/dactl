[GtkTemplate (ui = "/org/opendcs/dcs/ui/settings-page.ui")]
public class Dcsg.SettingsPage : Gtk.Box {

    [GtkChild]
    protected Gtk.Box box_treeview;

    [GtkChild]
    protected Gtk.Box box_listbox;

    protected Cld.Context cld_ctx;

    protected Dcsg.SettingsTreeView treeview;

    protected Dcsg.SettingsListBox listbox;

    construct {
        cld_ctx = Dcsg.Application.get_default ().model.ctx;
    }
}

public class Dcsg.CldSettingsPage : Dcsg.SettingsPage {

    public Dcsg.CldSettingsData data;

    construct {
        treeview = new Dcsg.CldSettingsTreeView ();
        box_treeview.pack_start (treeview);

        listbox = new Dcsg.SettingsListBox ();
        box_listbox.pack_start (listbox);

        (treeview as Dcsg.CldSettingsTreeView).select.connect ((uri) => {
            listbox.populate (data.get (uri));
            data.uri_selected = uri;
        });

        listbox.request_choices.connect ((source, box, type) => {
            if (type.is_a (typeof (Cld.Object))) {
                var map = cld_ctx.get_object_map_from_uri (type);
                box.set_cld_object_choices (map);
            }
        });

        listbox.new_data.connect ((source, spec, value) => {
            data.set_value (spec, value);
        });
    }
}

public class Dcsg.NativeSettingsPage : Dcsg.SettingsPage {
    protected Dcsg.Application app = Dcsg.Application.get_default ();

    public Dcsg.NativeSettingsData data;

    construct {
        treeview = new Dcsg.NativeSettingsTreeView ();
        box_treeview.pack_start (treeview);

        listbox = new Dcsg.SettingsListBox ();
        box_listbox.pack_start (listbox);

        (treeview as Dcsg.NativeSettingsTreeView).select.connect ((object) => {
            listbox.populate (data.get (object));
            data.object_selected = object;
        });

        listbox.request_choices.connect ((source, box, type) => {
            if (type.is_a (typeof (Dcs.Object))) {
                var map = app.model.get_object_map (type);
                box.set_dcs_object_choices (map);
            }

            if (type.is_a (typeof (Cld.Object))) {
                var map = cld_ctx.get_object_map_from_uri (type);
                box.set_cld_object_choices (map);
            }
        });

        listbox.new_data.connect ((source, spec, value) => {
            data.set_value (spec, value);
        });
    }
}

public class Dcsg.AcquisitionSettings : Dcsg.CldSettingsPage {
    construct {
        Cld.AcquisitionController acq = null;

        var acquisition_controllers = cld_ctx.
                   get_object_map_from_uri (typeof (Cld.AcquisitionController));
        /* Choose the last one. There should only be one */
        foreach (var ctrl in acquisition_controllers.values)
            acq = ctrl as Cld.AcquisitionController;

        (treeview as Dcsg.CldSettingsTreeView).generate (acq, 0);
        data = new Dcsg.CldSettingsData.from_object (acq);

        /* Add the data series to this page */
        var ds_map = cld_ctx.get_object_map_from_uri (typeof (Cld.DataSeries));
        foreach (var ds in ds_map.values) {
            (treeview as Dcsg.CldSettingsTreeView).generate (ds, 0);
            data.copy_settings (ds);
        }

        var math_map = cld_ctx.get_object_map_from_uri (typeof (Cld.MathChannel));
        foreach (var mc in math_map.values) {
            (treeview as Dcsg.CldSettingsTreeView).generate (mc, 0);
            data.copy_settings (mc);
        }
        show_all ();
    }
}

public class Dcsg.LogSettings : Dcsg.CldSettingsPage {
    construct {
        Cld.LogController log_ctrl = null;
        var log_controllers = cld_ctx.
                   get_object_map_from_uri (typeof (Cld.LogController));
        /* Choose the last one. There should only be one */
        foreach (var ctrl in log_controllers.values)
            log_ctrl = ctrl as Cld.LogController;

        (treeview as Dcsg.CldSettingsTreeView).generate (log_ctrl, 0);
        data = new Dcsg.CldSettingsData.from_object (log_ctrl);

        show_all ();
    }
}

public class Dcsg.ControlSettings : Dcsg.CldSettingsPage {
    construct {
        Cld.AutomationController auto_ctrl = null;
        var automation_controllers = cld_ctx.
                   get_object_map_from_uri (typeof (Cld.AutomationController));
        /* Choose the last one. There should only be one */
        foreach (var ctrl in automation_controllers.values)
            auto_ctrl = ctrl as Cld.AutomationController;

        (treeview as Dcsg.CldSettingsTreeView).generate (auto_ctrl, 0);
        data = new Dcsg.CldSettingsData.from_object (auto_ctrl);

        show_all ();
    }
}

public class Dcsg.PluginSettings : Dcsg.CldSettingsPage {
    construct {
        var module_map = cld_ctx.get_object_map_from_uri (typeof (Cld.Module));
        foreach (var module in module_map.values) {
            (treeview as Dcsg.CldSettingsTreeView).generate (module, 0);
            if (data == null)
                data = new Dcsg.CldSettingsData.from_object (module);
            else
                data.copy_settings (module);
        }

        show_all ();
    }
}

public class Dcsg.WidgetSettings : Dcsg.NativeSettingsPage {
    construct {
        var charts = app.model.get_object_map (typeof (Dcs.CompositeWidget));
        (treeview as Dcsg.NativeSettingsTreeView).generate (charts, 0);
        data = new Dcsg.NativeSettingsData.from_map (charts);

        show_all ();
    }
}

