/*
 *public abstract class Dcs.AbstractGraph<T> : Dcs.AbstractBuildable, Dcs.Graph<T> {
 *}
 */

/**
 * XXX Just here during development as a stub so that the unit test can compile.
 */
public abstract class Dcs.AbstractGraph : GLib.Object { }

public abstract class Dcs.AbstractDigraph : GLib.Object { }

public interface Dcs.Digraph : Dcs.Graph { }

public interface Dcs.Graph : Gee.ArrayList { }

//public interface Dcs.Digraph<G> : Dcs.Graph<G> { }

//public interface Dcs.Graph<G> : Gee.ArrayList<G> { }
