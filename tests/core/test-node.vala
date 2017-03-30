/**
 * Mock object to instantiate an abstract class for testing.
 */
public class Dcs.Test.Node : Dcs.Node {

    /**
     * {@inheritDoc}
     */
    public override string id { get; set; }

    public Node (string id) {
        this.id = id;
    }

    /**
     * {@inheritDoc}
     */
    public override string serialize () throws GLib.Error {
        assert (true);
        /*throw new Dcs.SerializationError.INVALID_TYPE ("Nothing is implemented yet");*/

        return "Nothing implemented yet";
    }

    /**
     * {@inheritDoc}
     */
    public override void deserialize (string data) throws GLib.Error {
        assert (true);
        /*throw new Dcs.SerializationError.INVALID_TYPE ("Nothing is implemented yet");*/
    }
}
