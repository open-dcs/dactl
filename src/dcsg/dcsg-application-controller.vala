public class Dcsg.ApplicationController : Dcs.ApplicationController {

    public ApplicationController (Dcsg.ApplicationModel model,
                                  Dcsg.ApplicationView view) {
        base (model, view);

        var app = Dcsg.Application.get_default ();
        app.save_requested.connect (save_requested_cb);
        app.closed.connect (() => {
            (app as GLib.Application).quit ();
        });
    }
}
