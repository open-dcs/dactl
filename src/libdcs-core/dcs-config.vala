public errordomain Dcs.ConfigError {
    FILE_NOT_FOUND,
    NO_VALUE_SET,
    VALUE_OUT_OF_RANGE,
    INVALID_FORMAT,
    INVALID_NAMESPACE,
    INVALID_KEY,
    INVALID_XPATH_EXPR,
    XML_DOCUMENT_EMPTY
}

public enum Dcs.ConfigFormat {
    OPTIONS,
    INI,
    JSON,
    XML,
    MIXED;

    public bool is_valid () {
        switch (this) {
            case OPTIONS: return true;
            case INI:     return true;
            case JSON:    return true;
            case XML:     return true;
            case MIXED:   return true;
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
     * TODO fill me in
     */
    public abstract string get_namespace () throws GLib.Error;

    /**
     * TODO fill me in
     */
    public abstract Dcs.ConfigFormat get_format () throws GLib.Error;

    /**
     * TODO fill me in
     */
    public abstract string get_string (string ns,
                                       string key)
                                       throws GLib.Error;

    /**
     * TODO fill me in
     */
    public abstract Gee.ArrayList<string> get_string_list (string ns,
                                                           string key)
                                                           throws GLib.Error;

    /**
     * TODO fill me in
     */
    public abstract int get_int (string ns,
                                 string key)
                                 throws GLib.Error;

    /**
     * TODO fill me in
     */
    public abstract Gee.ArrayList<int> get_int_list (string ns,
                                                     string key)
                                                     throws GLib.Error;

    /**
     * TODO fill me in
     */
    public abstract bool get_bool (string ns,
                                   string key)
                                   throws GLib.Error;

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
