/**
 *
 * A container for property values that are within the Cld namespace
 *
 */
public class Dcsg.CldSettingsData : Gee.HashMap<string, Dcsg.SettingValues> {
    public string uri_selected { private get; set; }

    public signal void new_data (string uri, GLib.ParamSpec spec, GLib.Value value);

    public bool admin = false;

    public CldSettingsData.from_object (Cld.Object object) {
        var app = Dcsg.Application.get_default ();
        admin = app.model.admin;
        copy_settings (object);
    }

    /**
     * Recursively copies properties from a Cld.Object to this
     *
     * @param object The object that is to have its properties copied
     *
     */
    public void copy_settings (Cld.Object object) {
        GLib.Type type = object.get_type ();
        GLib.ObjectClass ocl = (GLib.ObjectClass)type.class_ref ();
        Dcsg.SettingValues svalues = new SettingValues ();
        set (object.uri, svalues);
        foreach (var spec in ocl.list_properties ()) {
            bool writable = (spec.flags & GLib.ParamFlags.WRITABLE) ==
                                                       GLib.ParamFlags.WRITABLE;
            if (writable || admin) {
                Value value = Value (spec.value_type);//returns the default value for this type

                object.get_property (spec.get_name (), ref value);
                Dcsg.SettingValue val = new Dcsg.SettingValue (value);
                svalues.set (spec, val);
            }
        }

        if (object is Cld.Container) {
            foreach (var obj in (object as Cld.Container).get_objects ().values)
                copy_settings (obj);
        }
    }

    /**
     * Sets a single value in this that corresponds to a property value
     * of a Cld.Object
     *
     * @param spec specifies the parameter to be set
     * @param value the value to be set
     */
    public void set_value (GLib.ParamSpec spec, GLib.Value value) {
        var svalues = get (uri_selected);
        Dcsg.SettingValue val = new Dcsg.SettingValue (value);
        svalues.set (spec, val);
        new_data (uri_selected, spec, value);
    }
}

/**
 *
 * A container for property values that are within the Dcsg namespace
 *
 */
public class Dcsg.NativeSettingsData : Gee.HashMap<Dcs.Object, Dcsg.SettingValues>  {
    public Dcs.Object object_selected { private get; set; }

    public signal void new_data (Dcs.Object object, GLib.ParamSpec spec, GLib.Value value);

    public bool admin = false;

    public NativeSettingsData.from_map (Gee.Map<string, Dcs.Object> map) {
        var app = Dcsg.Application.get_default ();
        admin = app.model.admin;
        foreach (var object in map.values) {
            copy_settings (object);
        }
    }

    /**
     * Recursively copies properties from a Dcs.Object to this
     *
     * @param object The object that is to have its properties copied
     *
     */
    public void copy_settings (Dcs.Object object) {
        GLib.Type type = object.get_type ();
        GLib.ObjectClass ocl = (GLib.ObjectClass)type.class_ref ();
        Dcsg.SettingValues svalues = new SettingValues ();
        set (object, svalues);
        foreach (var spec in ocl.list_properties ()) {
            bool writable = (spec.flags & GLib.ParamFlags.WRITABLE) ==
                                                       GLib.ParamFlags.WRITABLE;
            bool readable = (spec.flags & GLib.ParamFlags.READABLE) ==
                                                       GLib.ParamFlags.READABLE;
            if (readable) {
                if (writable || admin) {
                    Value value = Value (spec.value_type);//returns the default value for this type

                    object.get_property (spec.get_name (), ref value);
                    Dcsg.SettingValue val = new Dcsg.SettingValue (value);
                    svalues.set (spec, val);
                }
            }
        }

        if (object is Dcs.Container) {
            foreach (var obj in (object as Dcs.Container).objects.values)
                copy_settings (obj);
        }
    }

    /**
     * Sets a single value in this that corresponds to a property value
     * of a Dcs.Object
     *
     * @param spec specifies the parameter to be set
     * @param value the value to be set
     */
    public void set_value (GLib.ParamSpec spec, GLib.Value value) {
        var svalues = get (object_selected);
        Dcsg.SettingValue val = new Dcsg.SettingValue (value);
        svalues.set (spec, val);
        new_data (object_selected, spec, value);
    }
}

public class Dcsg.SettingValues : Gee.HashMap<GLib.ParamSpec, Dcsg.SettingValue> {

}

public class Dcsg.SettingValue : GLib.Object {
    public GLib.Value value;

    public SettingValue (GLib.Value value) {
        this.value = value;
    }
}
