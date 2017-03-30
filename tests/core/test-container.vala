/**
 * Mock object to instantiate an abstract class for testing.
 */
public class Dcs.Test.Container : Dcs.AbstractContainer {

    /**
     * The map collection of the objects that belong to the container.
     */
    public override Gee.Map<string, Dcs.Object> objects { get; set; }

    public Container (string id) {
        this.id = id;
        this.objects = new Gee.TreeMap<string, Dcs.Object> ();
    }

    public void update_objects (Gee.Map<string, Dcs.Object> val) {
    }
}
