public errordomain Dcs.ViewError {
    INVALID_VIEW_REQUEST
}

/**
 * A common interface for different types of user interfaces.
 *
 * XXX not sure how this fits in yet, possible rename to View and AbstractView
 *     and base the UI and CLI views off of these.
 * XXX should these be buildable? if so that would allow for a configuration
 *     selectable interface.
 */
//[GenericAccessors]
//public interface Dcs.View : GLib.Object {

    /**
     * Used to select application administrative features.
     */
    //public abstract bool admin { get; set; }

    /**
     * Read-only property to tell if the interface is active.
     */
    //public abstract bool active { get; private set; }

    /**
     * Launch the interface.
     */
    //public abstract void launch ();

    /**
     * Shutdown the interface.
     */
    //public abstract void shutdown ();

    /**
     * When the interface has been launched.
     */
    //public abstract signal void opened ();

    /**
     * When the interface has been shutdown.
     */
    //public abstract signal void closed ();
//}

[GenericAccessors]
public interface Dcs.App.View : GLib.Object {

    /**
     * Add an object to the view.
     *
     * @param object The object to add
     * @param path The path in the object tree to add the object at.
     */
    public abstract void add (owned Dcs.Object object, string path) throws GLib.Error;
}
