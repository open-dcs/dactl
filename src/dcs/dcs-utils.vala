/**
 * Taken from Folks.
 */
private class Dcs.Utils {

    /* The current indentation level, in spaces */
    private static uint indentation = 0;
    private static string indentation_string = "";

    /* The FILE we're printing output to. */
    public static unowned FileStream output_filestream = GLib.stdout;

    public static void init () {
        Utils.indentation_string = "";
        Utils.indentation = 0;
        Utils.output_filestream = GLib.stdout;
    }

    public static void indent () {
        /* We indent in increments of two spaces */
        Utils.indentation += 2;
        Utils.indentation_string = string.nfill (Utils.indentation, ' ');
    }

    public static void unindent () {
        Utils.indentation -= 2;
        Utils.indentation_string = string.nfill (Utils.indentation, ' ');
    }

    [PrintfFormat ()]
    public static void print_line (string format, ...) {
        /* FIXME: store the va_list temporarily to work around bgo#638308 */
        var valist = va_list ();
        string output = format.vprintf (valist);
        var str = "%s%s\n".printf (Utils.indentation_string, output);
        Utils.output_filestream.printf (str);
    }

    /* FIXME: This can't be in the command_completion_cb() function because Vala
     * doesn't allow static local variables. From Folks. */
    private static Gee.MapIterator<string, Command>? command_name_iter = null;

    /* Complete a command name, starting with @word. */
    public static string? command_name_completion_cb (string word, int state) {
        /* Initialise state. Whoever wrote the readline API should be shot. */
        if (state == 0)
            Utils.command_name_iter = main_client.commands.map_iterator ();

        while (Utils.command_name_iter.next () == true) {
            string command_name = Utils.command_name_iter.get_key ();
            if (command_name.has_prefix (word))
                return command_name;
        }

        /* Clean up */
        Utils.command_name_iter = null;
        return null;
    }

    /* Command validation code for commands which take a well-known set of
     * subcommands. */
    public static bool validate_subcommand (string command,
                                            string? command_string,
                                            string? subcommand,
                                            string[] valid_subcommands) {
        if (subcommand != null && subcommand in valid_subcommands)
            return true;

        /* Print an error. */
        Utils.print_line ("Unrecognised '%s' command '%s'.",
                          command,
                          (command_string != null) ? command_string : "");

        Utils.print_line ("Valid commands:");
        Utils.indent ();
        foreach (var c in valid_subcommands)
            Utils.print_line ("%s", c);
        Utils.unindent ();

        return false;
    }
}
