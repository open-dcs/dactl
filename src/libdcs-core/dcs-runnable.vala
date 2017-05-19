public errordomain Dcs.RunnableError {
    UNDEFINED
}

/**
 * Defines run state requirements of implementor.
 *
 * An interface that can be implemented by anything that needs to have it's
 * run state controlled. This could include applications, plugins, tasks.
 */
public interface Dcs.Runnable : GLib.Object {

    /**
     * Change the state to started/running.
     */
    protected abstract void start () throws GLib.Error;

    /**
     * Change the state to paused/on hold.
     */
    protected abstract void pause () throws GLib.Error;

    /**
     * Change the state to stopped/not running.
     */
    protected abstract void stop () throws GLib.Error;
}
