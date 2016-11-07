public class Dcsg.Controller : Dcs.Controller {

    public Controller (Dcsg.Model model, Dcsg.Window view) {
        base (model, view);

        var app = Dcsg.Application.get_default ();
        app.save_requested.connect (save_requested_cb);
        app.closed.connect (() => {
            (app as GLib.Application).quit ();
        });
    }

    public void init () {
        (view as Dcsg.Window).maximize ();
        (view as Dcsg.Window).show_all ();

        (view as Gtk.ApplicationWindow).present ();

        /* Load the layout from either the configuration or use the default */
        (view as Dcsg.Window).construct_layout ();
    }

    /**
     * {@inheritDoc}
     */
    public override void update_view () {
        (view as Gtk.Widget).show_all ();
    }

    /**
     * {@inheritDoc}
     */
    public override void add (owned Dcs.Object object, string path)
                              throws GLib.Error {
        if (path == "" || path == "/" || path == null) {
            if (object is Dcs.UI.Page) {
                (view as Dcsg.Window).layout_add_page (object as Dcs.UI.Page);
            } else if (object is Dcs.UI.Window) {
                (view as Dcsg.Window).add_window (object as Dcs.UI.Window);
            }
        } else {
            var tokens = path.split ("/");
            var id = tokens[tokens.length - 1];
            var parent = model.get_object (id);

            debug (" <<<< %s >>>>", id);

            if (parent == null) {
                throw new Dcs.ApplicationError.INVALID_ADD_REQUEST (
                    "The object at the path provided does not exist.");
                return;
            }

            if (parent is Dcs.Container) {
                if (parent is Dcs.UI.Window) {
                    (parent as Dcs.UI.Window).add_child (object);
                    debug (" <<<< add %s to window >>>>", object.id);
                } else if (parent is Dcs.UI.Page) {
                    (parent as Dcs.UI.Page).add_child (object);
                    debug (" <<<< add %s to page >>>>", object.id);
                } else if (parent is Dcs.UI.Box) {
                    (parent as Dcs.UI.Box).add_child (object);
                    debug (" <<<< add %s to box >>>>", object.id);
                }
                (parent as Gtk.Widget).show_all ();
            } else {
                throw new Dcs.ApplicationError.INVALID_ADD_REQUEST (
                    "The object at the path provided is not a container.");
            }
        }
    }

    /**
     * {@inheritDoc}
     */
    public override void remove (string path)
                                 throws GLib.Error {
        debug ("remove: %s", path);
    }

    /**
     * {@inheritDoc}
     */
    public override void @set (string uri, Variant value) throws GLib.Error {
        debug ("set: %s -> %s", uri, value.print (false));
    }

    /**
     * {@inheritDoc}
     */
    public override Variant @get (string uri) throws GLib.Error {
        debug ("get: %s", uri);
        return new Variant.boolean (false);
    }
}
