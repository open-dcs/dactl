/**
 * To compile:
 *
 * TODO: this seems unnecessary, should fix
 *
 *   valac -X -I../src/libdcs-ui/ -X -I../src/libdcs-core/ \
 *      -X -L../src/libdcs-ui/ -X -L../src/libdcs-core/ \
 *      -X -ldcs-ui-0.1 -X -ldcs-core-0.1 --vapidir ../src/libdcs-core/ \
 *      --vapidir ../src/libdcs-ui/ --pkg libdcs-ui-0.1 box.vala
 */

private static int main (string[] args) {

    Gtk.init (ref args);

    var window = new Gtk.Window ();
    var box = new Dcs.UI.Box ();
    (box as Gtk.Box).orientation = Gtk.Orientation.HORIZONTAL;

    Type type = typeof (Dcs.UI.Box);
    stdout.printf ("\n--- ex: %s ---\n\n", type.name ());

    window.add (box);

    window.destroy.connect (Gtk.main_quit);
    window.show_all ();

    Gtk.main ();

    return 0;
}
