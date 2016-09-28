[Compact]
public class Dcs.Point : GLib.Object {
    public double x { get; set; default = 0.0; }
    public double y { get; set; default = 0.0; }

    public Point (double x, double y) {
        GLib.Object (x : x, y : y);
    }
}

public struct Dcs.SimplePoint {
    double x;
    double y;
}

public struct Dcs.TriplePoint {
    public double a;
    public double b;
    public double c;
}
