/**
 * Base class that can be used for configuration implementations.
 *
 * XXX This only exists to have something to use in unit tests for now. Throwing
 *     errors masks cases where the implementing class hasn't provided an
 *     overriding method.
 */
public class Dcs.BaseConfig : Dcs.Config, GLib.Object {

    protected Dcs.ConfigFormat format;

    public virtual string get_namespace () throws GLib.Error {
        throw new ConfigError.NO_VALUE_SET (_("No value available"));
    }

    public virtual Dcs.ConfigFormat get_format () throws GLib.Error {
        throw new ConfigError.NO_VALUE_SET (_("No value available"));
    }

    public virtual string get_string (string ns,
                                      string key)
                                      throws GLib.Error {
        throw new ConfigError.NO_VALUE_SET (_("No value available"));
    }

    public virtual Gee.ArrayList<string> get_string_list (string ns,
                                                          string key)
                                                          throws GLib.Error {
        throw new ConfigError.NO_VALUE_SET (_("No value available"));
    }

    public virtual int get_int (string ns,
                                string key)
                                throws GLib.Error {
        throw new ConfigError.NO_VALUE_SET (_("No value available"));
    }

    public virtual Gee.ArrayList<int> get_int_list (string ns,
                                                    string key)
                                                    throws GLib.Error {
        throw new ConfigError.NO_VALUE_SET (_("No value available"));
    }

    public virtual bool get_bool (string ns,
                                  string key)
                                  throws GLib.Error {
        throw new ConfigError.NO_VALUE_SET (_("No value available"));
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
