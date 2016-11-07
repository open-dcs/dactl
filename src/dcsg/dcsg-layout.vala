/**
 * Layout class that's used by the view.
 */
public class Dcsg.Layout : GLib.Object {

    private Dcs.Model model;

    public void Layout (Dcs.Model model) {
        this.model = model;
    }

    public void build () {
        var pages = model.get_object_map (typeof (Dcs.UI.Page));
        if (pages.size == 0) {
            var page = new Dcs.UI.Page ();
            page.id = "pg0";
            debug ("Layout default page `%s'", page.id);
            add (page, null);
        } else {
            foreach (var page in pages.values) {
                debug ("Layout page `%s'", page.id);
                //add (page, (page as Dcs.Object).parent);
                add (page, "derp");
            }
        }
    }

    /**
     * XXX Really unsure how to handle chaining requests to the parent.
     *     Why would you add windows here though? That doesn't really make sense
     *     and probably belongs to the application or the view.
     */
    public void add (Dcs.Object object, string parent) {
        if (parent == "" || parent == "root" || parent == null) {
            if (object is Dcs.UI.Page) {
                debug ("Layout page `%s' with title `%s'",
                       object.id, (object as Dcs.UI.Page).title);
                // XXX add a page to the parent view? signal?
                // request ("add", object, "root");
                // XXX manage the page list here or the view?
                model.add_child (object);
            } else if (object is Dcs.UI.Window) {
                // XXX add a window to the parent view? signal?
                // request ("add", object, null);
            }
        } else {
            // XXX similar problems here - add by signal?
        }
    }

    public void next () {
    }

    public void prev () {
    }
}
