/**
 * Base class that can be used for configuration implementations.
 *
 * XXX This only exists to have something to use in unit tests for now. Throwing
 * errors masks cases where the implementing class hasn't provided an
 * overriding method.
 */
public abstract class Dcs.AbstractConfig : Dcs.Config, GLib.Object {

    protected Dcs.ConfigFormat format;

    protected string @namespace = "dcs";

    protected Gee.ArrayList<Dcs.ConfigNode> children;

    /**
     * Check if the list of config node children is empty.
     *
     * @return True if the config contains child config nodes, false if not.
     */
    public bool has_children () {
        if (children == null) {
            return false;
        } else if (children.size > 0) {
            return true;
        }
        return false;
    }

    /**
     * Retrieve the list of configuration node children.
     *
     * @return List of configuration node children contained in this config.
     */
    public virtual Gee.List<Dcs.ConfigNode> get_children () {
        return children.read_only_view;
    }

    /**
     * {@inheritDoc}
     */
    public virtual void dump (GLib.FileStream stream) {
        /* TODO ??? */
    }

    /**
     * {@inheritDoc}
     */
    public virtual string get_namespace () throws GLib.Error {
        if (@namespace == null) {
            throw new ConfigError.NO_VALUE_SET (_("No value available"));
        }
        return @namespace;
    }

    /**
     * {@inheritDoc}
     */
    public virtual Dcs.ConfigFormat get_format () throws GLib.Error {
        throw new ConfigError.NO_VALUE_SET (_("No value available"));
    }

    /**
     * {@inheritDoc}
     */
    public virtual string get_string (string ns,
                                      string key)
                                      throws GLib.Error {
        throw new ConfigError.NO_VALUE_SET (_("No value available"));
    }

    /**
     * {@inheritDoc}
     */
    public virtual Gee.ArrayList<string> get_string_list (string ns,
                                                          string key)
                                                          throws GLib.Error {
        throw new ConfigError.NO_VALUE_SET (_("No value available"));
    }

    /**
     * {@inheritDoc}
     */
    public virtual int get_int (string ns,
                                string key)
                                throws GLib.Error {
        throw new ConfigError.NO_VALUE_SET (_("No value available"));
    }

    /**
     * {@inheritDoc}
     */
    public virtual Gee.ArrayList<int> get_int_list (string ns,
                                                    string key)
                                                    throws GLib.Error {
        throw new ConfigError.NO_VALUE_SET (_("No value available"));
    }

    /**
     * {@inheritDoc}
     */
    public virtual bool get_bool (string ns,
                                  string key)
                                  throws GLib.Error {
        throw new ConfigError.NO_VALUE_SET (_("No value available"));
    }

    /**
     * {@inheritDoc}
     */
    public virtual Gee.ArrayList<bool> get_bool_list (string ns,
                                                      string key)
                                                      throws GLib.Error {
        throw new ConfigError.NO_VALUE_SET (_("No value available"));
    }

    /**
     * {@inheritDoc}
     */
    public virtual double get_double (string ns,
                                      string key) throws GLib.Error {
        throw new ConfigError.NO_VALUE_SET (_("No value available"));
    }

    /**
     * {@inheritDoc}
     */
    public virtual Gee.ArrayList<double?> get_double_list (string ns,
                                                           string key)
                                                           throws GLib.Error {
        throw new ConfigError.NO_VALUE_SET (_("No value available"));
    }

    /**
     * {@inheritDoc}
     */
    public virtual Dcs.ConfigNode get_node (string ns,
                                            string key) throws GLib.Error {
        throw new ConfigError.NO_VALUE_SET (_("No value available"));
    }

    /**
     * {@inheritDoc}
     */
    public virtual void set_string (string ns,
                                    string key,
                                    string value) throws GLib.Error {
        throw new ConfigError.NO_VALUE_SET (_("No value available"));
    }

    /**
     * {@inheritDoc}
     */
    public virtual void set_string_list (string ns,
                                         string key,
                                         string[] value) throws GLib.Error {
        throw new ConfigError.NO_VALUE_SET (_("No value available"));
    }

    /**
     * {@inheritDoc}
     */
    public virtual void set_int (string ns,
                                 string key,
                                 int value) throws GLib.Error {
        throw new ConfigError.NO_VALUE_SET (_("No value available"));
    }

    /**
     * {@inheritDoc}
     */
    public virtual void set_int_list (string ns,
                                      string key,
                                      int[] value) throws GLib.Error {
        throw new ConfigError.NO_VALUE_SET (_("No value available"));
    }

    /**
     * {@inheritDoc}
     */
    public virtual void set_bool (string ns,
                                  string key,
                                  bool value) throws GLib.Error {
        throw new ConfigError.NO_VALUE_SET (_("No value available"));
    }

    /**
     * {@inheritDoc}
     */
    public virtual void set_bool_list (string ns,
                                       string key,
                                       bool[] value) throws GLib.Error {
        throw new ConfigError.NO_VALUE_SET (_("No value available"));
    }

    /**
     * {@inheritDoc}
     */
    public virtual void set_double (string ns,
                                    string key,
                                    double value) throws GLib.Error {
        throw new ConfigError.NO_VALUE_SET (_("No value available"));
    }

    /**
     * {@inheritDoc}
     */
    public virtual void set_double_list (string ns,
                                         string key,
                                         double[] value) throws GLib.Error {
        throw new ConfigError.NO_VALUE_SET (_("No value available"));
    }

    /**
     * {@inheritDoc}
     */
    public virtual void set_node (string ns,
                                  string key,
                                  Dcs.ConfigNode? value) throws GLib.Error {
        throw new ConfigError.NO_VALUE_SET (_("No value available"));
    }
}
