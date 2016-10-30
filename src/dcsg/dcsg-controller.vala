public class Dcsg.Controller : Dcs.ApplicationController {

    public Controller (Dcsg.Model model, Dcsg.Window view) {
        base (model, view);

        var app = Dcsg.Application.get_default ();
        app.save_requested.connect (save_requested_cb);
        app.closed.connect (() => {
            (app as GLib.Application).quit ();
        });
    }
}
