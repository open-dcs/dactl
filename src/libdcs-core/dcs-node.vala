public abstract class Dcs.Node : Dcs.AbstractContainer, Dcs.RefContainer {

    /**
     * {@inheritDoc}
     */
    protected virtual Gee.Map<string, unowned Dcs.Node> references { get; private set; }

    /**
     * Parent of the node, null if this is the root.
     */
    public virtual Dcs.Node parent { get; private set; default = null; }

    /**
     * Child nodes in the tree.
     */
    protected Gee.Map<string, Dcs.Node> children;
}
