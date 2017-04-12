[DBus (name = "org.opendcs.Dcs.DAQ")]
internal class Dcs.DAQ.DBusService : GLib.Object, Dcs.DBusInterface {

    private Dcs.DAQ.Main main;
    private uint name_id;
    private uint connection_id;

    public DBusService (Dcs.DAQ.Main main) {
        this.main = main;
    }

    internal void publish () {
        this.name_id = Bus.own_name (BusType.SESSION,
                                     Dcs.DBusInterface.SERVICE_NAME + ".DAQ",
                                     BusNameOwnerFlags.NONE,
                                     this.on_bus_aquired,
                                     this.on_name_available,
                                     this.on_name_lost);
    }

    internal void unpublish () {
        if (connection_id != 0) {
            try {
                var connection = Bus.get_sync (BusType.SESSION);
                connection.unregister_object (this.connection_id);
            } catch (IOError error) {};
        }

        if (name_id != 0) {
            Bus.unown_name (this.name_id);
        }
    }

    private void on_bus_aquired (DBusConnection connection) {
        try {
            this.connection_id =
                connection.register_object (
                    Dcs.DBusInterface.OBJECT_PATH + "/DAQ", this
                );
        } catch (Error error) {
            critical ("Could not register service");
        }
    }

    private void on_name_available (DBusConnection connection) {
        this.main.dbus_available ();
    }

    private void on_name_lost (DBusConnection? connection) {
        if (connection == null) {
            // This means there is no DBus available at all
            this.main.dbus_available ();

            return;
        }

        message (_("Another instance of daq-server is already running. Not starting."));
        this.main.exit (-15);
    }

    /*** Test Methods ***/

    public void shutdown () throws IOError {
        debug (_("Received shutdown"));
        //quit_requested ();
        this.main.exit (0);
    }

    //public signal void quit_request ();

    public void restart () throws Error {
        debug (_("Restart requested"));
        this.main.restart ();
    }

    public string config_loaded () throws Error {
        var meta_config = Dcs.MetaConfig.get_default ();
        string val = "";
        try {
            val = meta_config.get_string ("app", "config");
        } catch (Error e) {
            throw e;
        }
        return val;
    }
}
