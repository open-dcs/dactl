[GtkTemplate (ui = "/org/opendcs/libdcs/ui/exec-control.ui")]
public class Dcs.UI.ExecControl : Dcs.UI.CompositeWidget {

    [GtkChild]
    private Gtk.Entry entry_command;

    private Gee.Map<string, Dcs.Object> _objects;

    /**
     * {@inheritDoc}
     */
    public override Gee.Map<string, Dcs.Object> objects {
        get { return _objects; }
        set { update_objects (value); }
    }

    construct {
        id = "exec-ctl0";

        objects = new Gee.TreeMap<string, Dcs.Object> ();
    }

    //public ExecControl (string command) {}

    public ExecControl.from_xml_node (Xml.Node *node) {
        build_from_xml_node (node);
    }

    /**
     * {@inheritDoc}
     */
    public override void build_from_xml_node (Xml.Node *node) {
        if (node->type == Xml.ElementType.ELEMENT_NODE &&
            node->type != Xml.ElementType.COMMENT_NODE) {
            id = node->get_prop ("id");
        }
    }

    [GtkCallback]
    private void btn_exec_clicked_cb () {
        string[] args = {};
        bool executable = GLib.FileUtils.test (entry_command.text, GLib.FileTest.IS_EXECUTABLE);
        if (executable) {
            var pid = Posix.fork ();
            if (pid == 0) {
                /* child */
                Posix.execvp (entry_command.text, args);
            } else {
                /* parent - do nothing */
            }
        } else {
            warning ("The command `%s' is not executable", entry_command.text);
        }
    }

    /**
     * {@inheritDoc}
     */
    public override void update_objects (Gee.Map<string, Dcs.Object> val) {
        _objects = val;
    }
}
