[DBus (name = "org.opendcs.Dcs")]
public interface Dcs.DBusInterface : GLib.Object {
    public const string SERVICE_NAME = "org.opendcs.Dcs";
    public const string OBJECT_PATH = "/org/opendcs/Dcs";

    public abstract void shutdown () throws IOError;
}
