public errordomain Dcs.ConfigError {
    FILE_NOT_FOUND,
    NO_VALUE_SET,
    NO_VALUE_FOUND,
    VALUE_OUT_OF_RANGE,
    INVALID_FORMAT,
    INVALID_NAMESPACE,
    INVALID_KEY,
    INVALID_PATH,
    INVALID_XPATH_EXPR,
    PROPERTY_TYPE,
    UNSUPPORTED_FORMAT,
    XML_DOCUMENT_EMPTY
}

public enum Dcs.ConfigFormat {
    OPTIONS,
    INI,
    JSON,
    XML,
    MIXED,
    INVALID;

    public bool is_valid () {
        switch (this) {
            case OPTIONS: return true;
            case INI:     return true;
            case JSON:    return true;
            case XML:     return true;
            case MIXED:   return true;
            case INVALID:
            default:      return false;
        }
    }
}

public enum Dcs.ConfigEntry {
    NAMESPACE,
    FORMAT
}

/**
 * Interface for handling DCS configurations.
 */
public interface Dcs.Config : GLib.Object {

    /**
     * Emitted when any known configuration setting has changed.
     */
    public signal void config_changed (Dcs.ConfigEntry entry);

    /**
     * Emitted when a custom setting has changed.
     */
    public signal void setting_changed (string ns, string key);

    /**
     * Check if the type of the property in the class given matches the desired
     * type provided.
     *
     * XXX Should this just return a boolean instead of throwing errors?
     *
     * @param class_type Class to check property existence and type correctness
     * @param check_type Type of the property to check against
     * @param property Name of the property to check
     *
     * @throws Dcs.ConfigError Configuration error, see {@link Dcs.ConfigError}.
     */
    public static void check_property_type (GLib.Type class_type,
                                            GLib.Type check_type,
                                            string property) throws GLib.Error {
        var ocl = (GLib.ObjectClass) class_type.class_ref ();
        unowned GLib.ParamSpec? spec = ocl.find_property (property);

        if (spec == null) {
            throw new Dcs.ConfigError.INVALID_KEY ("No property with that name");
        } else if (spec.value_type != check_type) {
            throw new Dcs.ConfigError.PROPERTY_TYPE (
                "The wrong type was requested for the property");
        }
    }

    /**
     * Dump the configuration to the file stream provided. Used for
     * debugging purposes.
     *
     * @param stream Output stream to write to.
     */
    public virtual void dump (GLib.FileStream stream) {
        var type = get_type ();
        stream.write (type.name ().data);
        stream.write ({ 13, 10 });
        var ocl = (GLib.ObjectClass) type.class_ref ();
        foreach (var spec in ocl.list_properties ()) {
            //GLib.Value value;
            //@get (spec.get_name (), out value);
            stream.write (spec.get_name ().data);
        }
    }

    /**
     * Get the configuration namespace used.
     *
     * @return Configuration namespace.
     *
     * @throws Dcs.ConfigError Configuration error, see {@link Dcs.ConfigError}.
     */
    public abstract string get_namespace () throws GLib.Error;

    /**
     * Get the current configuration format used.
     *
     * @return Configuration format, see {@link Dcs.ConfigFormat}.
     *
     * @throws Dcs.ConfigError Configuration error, see {@link Dcs.ConfigError}.
     */
    public abstract Dcs.ConfigFormat get_format () throws GLib.Error;

    /**
     * Retrieve a string property.
     *
     * @param ns Configuration namespace to search in.
     * @param key Property name to return.
     *
     * @return Property value at `key'.
     *
     * @throws Dcs.ConfigError Error if not found, see {@link Dcs.ConfigError}.
     */
    public abstract string get_string (string ns,
                                       string key)
                                       throws GLib.Error;

    /**
     * Retrieve a string list property.
     *
     * @param ns Configuration namespace to search in.
     * @param key Property name to return.
     *
     * @return Property value at `key'.
     *
     * @throws Dcs.ConfigError Error if not found, see {@link Dcs.ConfigError}.
     */
    public abstract Gee.ArrayList<string> get_string_list (string ns,
                                                           string key)
                                                           throws GLib.Error;

    /**
     * Retrieve an int property.
     *
     * @param ns Configuration namespace to search in.
     * @param key Property name to return.
     *
     * @return Property value at `key'.
     *
     * @throws Dcs.ConfigError Error if not found, see {@link Dcs.ConfigError}.
     */
    public abstract int get_int (string ns,
                                 string key)
                                 throws GLib.Error;

    /**
     * Retrieve an int list property.
     *
     * @param ns Configuration namespace to search in.
     * @param key Property name to return.
     *
     * @return Property value at `key'.
     *
     * @throws Dcs.ConfigError Error if not found, see {@link Dcs.ConfigError}.
     */
    public abstract Gee.ArrayList<int> get_int_list (string ns,
                                                     string key)
                                                     throws GLib.Error;

    /**
     * Retrieve a boolean property.
     *
     * @param ns Configuration namespace to search in.
     * @param key Property name to return.
     *
     * @return Property value at `key'.
     *
     * @throws Dcs.ConfigError Error if not found, see {@link Dcs.ConfigError}.
     */
    public abstract bool get_bool (string ns,
                                   string key)
                                   throws GLib.Error;

    /**
     * Retrieve a bool list property.
     *
     * @param ns Configuration namespace to search in.
     * @param key Property name to return.
     *
     * @return Property value at `key'.
     *
     * @throws Dcs.ConfigError Error if not found, see {@link Dcs.ConfigError}.
     */
    public abstract Gee.ArrayList<bool> get_bool_list (string ns,
                                                       string key)
                                                       throws GLib.Error;

    /**
     * Retrieve an double property.
     *
     * @param ns Configuration namespace to search in.
     * @param key Property name to return.
     *
     * @return Property value at `key'.
     *
     * @throws Dcs.ConfigError Error if not found, see {@link Dcs.ConfigError}.
     */
    public abstract double get_double (string ns,
                                       string key) throws GLib.Error;

    /**
     * Retrieve a double list property.
     *
     * @param ns Configuration namespace to search in.
     * @param key Property name to return.
     *
     * @return Property value at `key'.
     *
     * @throws Dcs.ConfigError Error if not found, see {@link Dcs.ConfigError}.
     */
    public abstract Gee.ArrayList<double?> get_double_list (string ns,
                                                            string key)
                                                            throws GLib.Error;

	/**
     * Retrieve a configuration node.
     *
     * @param ns Configuration namespace to search in.
     * @param key Node ID to return value for with optional path prefix.
     *
     * @return Configuration node value at `key'.
     *
     * @throws Dcs.ConfigError Error if not found, see {@link Dcs.ConfigError}.
     */
    public abstract Dcs.ConfigNode get_node (string ns,
                                             string key) throws GLib.Error;

    /**
     * TODO fill me in
     *
     * @param ns Configuration namespace to search in.
     * @param key Property name to set.
     *
     * @throws Dcs.ConfigError Error if not found, see {@link Dcs.ConfigError}.
     */
    public abstract void set_string (string ns,
                                     string key,
                                     string value) throws GLib.Error;

    /**
     * Set the value of a string list property with the name `key'.
     *
     * @param ns Configuration namespace to search in.
     * @param key Property name to set.
     *
     * @throws Dcs.ConfigError Error if not found, see {@link Dcs.ConfigError}.
     */
    public abstract void set_string_list (string ns,
                                          string key,
                                          string[] value) throws GLib.Error;

    /**
     * TODO fill me in
     *
     * @param ns Configuration namespace to search in.
     * @param key Property name to set.
     *
     * @throws Dcs.ConfigError Error if not found, see {@link Dcs.ConfigError}.
     */
    public abstract void set_int (string ns,
                                  string key,
                                  int value) throws GLib.Error;

    /**
     * Set the value of an int list property with the name `key'.
     *
     * @param ns Configuration namespace to search in.
     * @param key Property name to set.
     *
     * @throws Dcs.ConfigError Error if not found, see {@link Dcs.ConfigError}.
     */
    public abstract void set_int_list (string ns,
                                       string key,
                                       int[] value) throws GLib.Error;

    /**
     * TODO fill me in
     *
     * @param ns Configuration namespace to search in.
     * @param key Property name to set.
     *
     * @throws Dcs.ConfigError Error if not found, see {@link Dcs.ConfigError}.
     */
    public abstract void set_bool (string ns,
                                   string key,
                                   bool value) throws GLib.Error;

    /**
     * Set the value of a bool list property with the name `key'.
     *
     * @param ns Configuration namespace to search in.
     * @param key Property name to set.
     *
     * @throws Dcs.ConfigError Error if not found, see {@link Dcs.ConfigError}.
     */
    public abstract void set_bool_list (string ns,
                                        string key,
                                        bool[] value) throws GLib.Error;

    /**
     * TODO fill me in
     *
     * @param ns Configuration namespace to search in.
     * @param key Property name to set.
     *
     * @throws Dcs.ConfigError Error if not found, see {@link Dcs.ConfigError}.
     */
    public abstract void set_double (string ns,
                                     string key,
                                     double value) throws GLib.Error;

    /**
     * Set the value of a double list property with the name `key'.
     *
     * @param ns Configuration namespace to search in.
     * @param key Property name to set.
     *
     * @throws Dcs.ConfigError Error if not found, see {@link Dcs.ConfigError}.
     */
    public abstract void set_double_list (string ns,
                                          string key,
                                          double[] value) throws GLib.Error;

    /**
     * Update the configuration node with the one provided if it exists already,
     * add this as a new one if it doesn't, or delete one if it exists and
     * `value' is null.
     *
     * @param ns Configuration namespace to search in.
     * @param key Configuration node ID to set with an optional path prefix.
     * @param value Node to create/update/delete.
     *
     * @throws Dcs.ConfigError Error if not found, see {@link Dcs.ConfigError}.
     */
    public abstract void set_node (string ns,
                                   string key,
                                   Dcs.ConfigNode? value) throws GLib.Error;
}
