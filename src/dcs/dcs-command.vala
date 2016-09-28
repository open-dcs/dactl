/**
 * Command class concept taken from Folks.
 */
public abstract class Dcs.Command {

    protected Dcs.Client client;

    public Command (Dcs.Client client) {
        this.client = client;
    }

    public abstract string name { get; }
    public abstract string description { get; }
    public abstract string help { get; }

    public abstract async int run (string? command_string);

    public virtual string[]? complete_subcommand (string subcommand) {
        /* Default implementation */
        return null;
    }
}
