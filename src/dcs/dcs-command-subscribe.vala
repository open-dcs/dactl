private class Dcs.Commands.Subscribe : Dcs.Command {

    public override string name {
        get { return "subscribe"; }
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

    public Subscribe (Dcs.Client client) {
        base (client);
    }

  	public override async int run (string? command_string) {
        return 0;
    }
}
