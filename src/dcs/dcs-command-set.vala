private class Dcs.Commands.Set : Dcs.Command {

    public override string name {
        get { return "set"; }
    }

    public override string description {
        get {
            return ".";
        }
    }

    public override string help {
        get {
            return ".";
        }
    }

    public Set (Dcs.Client client) {
        base (client);
    }

  	public override async int run (string? command_string) {
        return 0;
    }
}
