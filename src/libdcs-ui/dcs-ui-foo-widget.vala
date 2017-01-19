public abstract class Dcs.UI.FooWidget : Gtk.Layout,
                                         Gtk.Buildable,
                                         Gtk.Scrollable,
                                         Atk.Implementor {

    protected virtual Dcs.UI.FooObject object { get; set; }

    public virtual bool fill { get; set; }
}
