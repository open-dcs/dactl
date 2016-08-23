/**
 * To compile:
 *
 * TODO: this seems unnecessary, should fix
 *
 *   valac -X -I../src/libdcs-ui/ -X -I../src/libdcs-core/ \
 *      -X -L../src/libdcs-ui/ -X -L../src/libdcs-core/ \
 *      -X -ldcs-ui-0.1 -X -ldcs-core-0.1 --vapidir ../src/libdcs-core/ \
 *      --vapidir ../src/libdcs-ui/ --pkg libdcs-ui-0.1 channel-treeview.vala
 */

private static int main (string[] args) {

    Gtk.init (ref args);

    var window = new Gtk.Window ();
    var treeview = new Dcs.UI.ChannelTreeView ();

    treeview.channels_loaded.connect (() => {
        message ("All channels have been loaded");
    });

    var channel = new Cld.AIChannel ();
    channel.id = "ai0";

    treeview.request_object.connect ((id) => {
        treeview.offer_cld_object (channel);
    });

    var calibration = new Cld.Calibration ();
    calibration.id = "cal0";
    (channel as Cld.Container).add (calibration);

    var entry = new Dcs.UI.ChannelTreeEntry ();
    entry.ch_ref = channel.id;

    var category = new Dcs.UI.ChannelTreeCategory ();
    category.add_child (entry);

    (treeview as Dcs.Container).add_child (category);

    window.add (treeview);

    window.destroy.connect (Gtk.main_quit);
    window.show_all ();

    Gtk.main ();

    return 0;
}
