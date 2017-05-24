public interface Dcs.Net.ServiceProvider : GLib.Object {

    public abstract Dcs.Net.Service service { get; construct set; }

    public abstract void activate ();

    public abstract void deactivate ();

    public abstract void start () throws GLib.Error;

    public abstract void pause () throws GLib.Error;

    public abstract void stop () throws GLib.Error;
}
