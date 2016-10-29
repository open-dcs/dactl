public errordomain Dcs.ConfigError {
    FILE_NOT_FOUND,
    NO_VALUE_SET,
    VALUE_OUT_OF_RANGE,
    INVALID_KEY,
    INVALID_XPATH_EXPR,
    XML_DOCUMENT_EMPTY
}

public enum Dcs.ConfigFormat {
    OPTIONS,
    INI,
    JSON,
    XML
}

public enum Dcs.ConfigEntry {
    NAME
}

/**
 * Interface for handling Dcs configuration.
 */
public abstract class Dcs.Config : GLib.Object {

    public virtual Dcs.ConfigFormat format { get; set; }

    /**
     * Emitted when any known configuration setting has changed.
     */
    public signal void config_changed (Dcs.ConfigEntry entry);

    /**
     * Emitted when a custom setting has changed.
     */
    public signal void setting_changed (string ns, string key);

    /**
     * Emitted when configuration data has been loaded.
     */
    public signal void config_loaded ();

    /**
     * Load a configuration file using the data provided.
     */
    public virtual void load_data (string data,
                                   Dcs.ConfigFormat format)
                                   throws GLib.Error {
        config_loaded ();
    }

    /**
     * TODO fill me in
     */
    public virtual string get_string (string ns,
                                      string key)
                                      throws GLib.Error {
		string value = null;

        if (value != null) {
            return value;
        } else {
            throw new ConfigError.NO_VALUE_SET (_("No value available"));
		}
    }

    /**
     * TODO fill me in
     */
    public virtual Gee.ArrayList<string> get_string_list (string ns,
                                                          string key)
                                                          throws GLib.Error {
        Gee.ArrayList<string> value = null;

        if (value != null) {
            return value;
        } else {
            throw new ConfigError.NO_VALUE_SET (_("No value available"));
		}
    }

    /**
     * TODO fill me in
     */
    public virtual int get_int (string ns,
                                string key)
                                throws GLib.Error {
		int value = 0;
		bool value_set = false;

        if (value_set) {
            return value;
        } else {
            throw new ConfigError.NO_VALUE_SET (_("No value available"));
		}
    }

    /**
     * TODO fill me in
     */
    public virtual Gee.ArrayList<int> get_int_list (string ns,
                                                    string key)
                                                    throws GLib.Error {
        Gee.ArrayList<int> value = null;

        if (value != null) {
            return value;
        } else {
            throw new ConfigError.NO_VALUE_SET (_("No value available"));
		}
    }

    /**
     * TODO fill me in
     */
    public virtual bool get_bool (string ns,
                                  string key)
                                  throws GLib.Error {
		bool value = false;
		bool value_set = false;

        if (value_set) {
            return value;
        } else {
            throw new ConfigError.NO_VALUE_SET (_("No value available"));
		}
    }

/*
 *    public abstract float get_float (string ns,
 *                                     string key) throws GLib.Error;
 *
 *    public abstract double get_double (string ns,
 *                                       string key) throws GLib.Error;
 *
 *    public abstract void set_string (string ns,
 *                                     string key,
 *                                     string value) throws GLib.Error;
 *
 *    public abstract void set_int (string ns,
 *                                  string key,
 *                                  int value) throws GLib.Error;
 *
 *    public abstract void set_bool (string ns,
 *                                   string key,
 *                                   bool value) throws GLib.Error;
 *
 *    public abstract void set_float (string ns,
 *                                    string key,
 *                                    float value) throws GLib.Error;
 *
 *    public abstract void set_double (string ns,
 *                                     string key,
 *                                     double value) throws GLib.Error;
 */
}
