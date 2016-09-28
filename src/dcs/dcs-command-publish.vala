private class Dcs.Commands.Publish : Dcs.Command {

    public override string name {
        get { return "publish"; }
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

    public Publish (Dcs.Client client) {
        base (client);
    }

  	public override async int run (string? command_string) {
        return 0;
    }
}
