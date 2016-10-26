/* We have to have a static global instance so that the readline callbacks can
 * access its data, since they don't pass closures around. */
static Dcs.Client main_client = null;

public class Dcs.Client : GLib.Object {

    public Gee.HashMap<string, Dcs.Command> commands;

    private GLib.MainLoop main_loop;
    private Dcs.SysLog log;

    /* A lot (okay all) of the readline functionality is taken from Folks, but
     * the pager stuff was omitted. May want to add that back later if output
     * from some of the commands is unreasonable to view without it. */
    private Posix.termios original_termios_p;
    private bool original_termios_p_valid = false;

    private static bool is_readline_installed;
    private static IOChannel? stdin_channel = null;
    private static uint stdin_watch_id = 0;

    /* Command line option entries recognized by this program. */
    private struct Options {

        public static bool version = false;

        public static const GLib.OptionEntry[] entries = {{
            "verbose", 'v', OptionFlags.NO_ARG, OptionArg.CALLBACK, (void *) verbose_cb,
            "Provide verbose debugging output.", null
        },{
            "version", 'V', 0, OptionArg.NONE, ref version,
            "Display version number.", null
        },{
            null
        }};
    }

    private static int main (string[] args) {

        int retval = 0;

        Intl.setlocale (LocaleCategory.ALL, "");
        Intl.bindtextdomain (Dcs.Build.GETTEXT_PACKAGE, Dcs.Build.LOCALEDIR);
        Intl.bind_textdomain_codeset (Dcs.Build.GETTEXT_PACKAGE, "UTF-8");
        Intl.textdomain (Dcs.Build.GETTEXT_PACKAGE);

        GLib.Environment.set_prgname (_(Dcs.Build.PACKAGE_NAME));
        GLib.Environment.set_application_name (_(Dcs.Build.PACKAGE_NAME));

        parse_local_args (ref args);
        main_client = new Dcs.Client ();

		/* Run the command. */

     	if (args.length == 1) {
            main_client.run_interactive.begin ();
            retval = 0;
        } else {
            GLib.assert (args.length > 1);

            /* Drop the first argument and parse the rest as a command line. If
             * the first argument is ‘--’ then the command was passed after some
             * flags. */
            string command_line;
            if (args[1] == "--") {
                command_line = string.joinv (" ", args[2:0]);
            } else {
                command_line = string.joinv (" ", args[1:0]);
            }

            main_client.run_non_interactive.begin (command_line, (obj, res) => {
                retval = main_client.run_non_interactive.end (res);
                main_client.quit ();
            });
        }

        /* Launch the application */
        main_client.main_loop.run ();

        return retval;
    }

    private Client () {
        log = Dcs.SysLog.get_default ();
        log.init (true, null);

        Utils.init ();

        commands = new Gee.HashMap<string, Dcs.Command> ();

        /* Register the commands that are supported */
        /* FIXME: This should be automatic */
        commands.set ("help", new Dcs.Commands.Help (this));
        commands.set ("set", new Dcs.Commands.Set (this));
        commands.set ("get", new Dcs.Commands.Get (this));
        commands.set ("publish", new Dcs.Commands.Publish (this));
        commands.set ("subscribe", new Dcs.Commands.Subscribe (this));
        commands.set ("request", new Dcs.Commands.Request (this));
        commands.set ("reply", new Dcs.Commands.Reply (this));
        commands.set ("quit", new Dcs.Commands.Quit (this));

        main_loop = new GLib.MainLoop ();

        Unix.signal_add (Posix.SIGHUP,  () => { this.quit (); return false; });
        Unix.signal_add (Posix.SIGTERM, () => { this.quit (); return false; });
    }

    /**
     * Quit the application and cleanup anything that needs to be.
     */
    public void quit () {
        Dcs.SysLog.shutdown ();

        if (Dcs.Client.is_readline_installed) {
            uninstall_readline_and_stdin ();
        }

        /* Restore the original terminal settings. */
        if (original_termios_p_valid) {
            Posix.tcsetattr (Posix.STDIN_FILENO,
                             Posix.TCSADRAIN,
                             original_termios_p);
        }

        /* Kill our main loop. */
        this.main_loop.quit ();
    }

    private static void parse_local_args (ref unowned string[] args) {
        var opt_context = new OptionContext ("[COMMAND]");
        opt_context.set_summary ("Utility to interact and test OpenDCS.");
        opt_context.set_ignore_unknown_options (true);
        opt_context.set_help_enabled (true);
        opt_context.add_main_entries (Options.entries, null);

        try {
            opt_context.parse (ref args);
        } catch (OptionError e) {
            error ("Couldn’t parse command line options: %s\n",
                   e.message);
        }

        if (Options.version) {
            stdout.printf (_("%s - version %s\n"), args[0],
                           Dcs.Build.PACKAGE_VERSION);
            Posix.exit (0);
        }
    }

    private bool verbose_cb () {
        Dcs.SysLog.increase_verbosity ();
        return true;
    }

    /**
     * Running in non-interactive mode executes a single command and outputs
     * the results.
     *
     * @param command_line The command and additional arguments.
     *
     * @return ``0`` for successful execution ``1`` otherwise.
     */
    public async int run_non_interactive (string command_line) {
        /* Check if the command can be parsed. */
        string subcommand;
        string command_name;
        var command = Dcs.Client.parse_command_line (command_line,
                                                     out command_name,
                                                     out subcommand);

        if (command == null) {
            warning ("Unrecognized command '%s'.", command_name);
            return 1;
        }

        /* Run the command */
        int retval = yield command.run (subcommand);
        this.quit ();

        return retval;
    }

    /**
     * Running in interactive mode provides a shell that allows interaction with
     * other components of OpenDCS using a set of commands that uses the various
     * service types offered.
     */
    public async int run_interactive () {
        /* Copy the original terminal settings. */
        if (Posix.tcgetattr (Posix.STDIN_FILENO, out original_termios_p) == 0) {
            original_termios_p_valid = true;
        }

        /* Handle the SIGINT signal */
        Unix.signal_add (Posix.SIGINT, () => {
            if (Dcs.Client.is_readline_installed == false) {
                return true;
            }

            /* Tidy up readline */
            Readline.free_line_state ();
            Readline.cleanup_after_signal ();
            Readline.reset_after_signal ();

            /* Display a fresh prompt. */
            GLib.stdout.printf ("^C");
            Readline.crlf ();
            Readline.reset_line_state ();
            Readline.replace_line ("", 0);
            Readline.redisplay ();

            return true;
        });

        /* Allow things to be set in ~/.inputrc and install our own
         * completion function. */
        Readline.readline_name = "dcs";
        Readline.attempted_completion_function = Dcs.Client.readline_completion_cb;
        Readline.catch_signals = 0;

        /* Install readline and the stdin handler */
        stdin_channel = new IOChannel.unix_new (GLib.stdin.fileno ());
        install_readline_and_stdin ();

        return 0;
    }

    private void install_readline_and_stdin () {
        Dcs.Client.stdin_watch_id = stdin_channel.add_watch (IOCondition.IN,
                                                             stdin_handler_cb);

        /* Callback for each character that appears on stdin. */
        Readline.callback_handler_install (">> ", Dcs.Client.readline_handler_cb);
        Dcs.Client.is_readline_installed = true;
    }

    private void uninstall_readline_and_stdin () {
        Readline.callback_handler_remove ();
        Dcs.Client.is_readline_installed = false;

        GLib.Source.remove (Client.stdin_watch_id);
        Dcs.Client.stdin_watch_id = 0;
    }

    /* This should only be called while readline is installed. */
    private bool stdin_handler_cb (IOChannel source, IOCondition cond) {
        /* Let readline consume any characters that are available on stdin. */
        if ((cond & IOCondition.IN) != 0) {
            Readline.callback_read_char ();
            return true;
        }

        assert_not_reached ();
    }

    private static void readline_handler_cb (string? _command_line) {
        if (_command_line == null) {
            /* EOF. Do nothing if there's text, quit otherwise. */
            if (Readline.line_buffer != "") {
                Readline.ding ();
                return;
            }

            main_client.quit ();

            return;
        }

        var command_line = (!) _command_line;

        command_line = command_line.strip ();
        if (command_line == "") {
            /* If the user enters a blank line just display a new prompt. */
            return;
        }

        string subcommand;
        string command_name;
        Dcs.Command command = Dcs.Client.parse_command_line (command_line,
                                                             out command_name,
                                                             out subcommand);

        /* Run the command if one was found. */
        if (command != null) {
            command.run.begin (subcommand, (obj, res) => {
                command.run.end (res);

                /* Clean up */
                Readline.reset_line_state ();
                Readline.replace_line ("", 0);
                Readline.redisplay ();
            });
        } else {
            warning ("Unrecognized command '%s'.", command_name);
        }

        /* Save the command in history, even unrecognized ones. */
        Readline.History.add (command_line);
    }

    private static Dcs.Command? parse_command_line (string command_line,
                                                    out string command_name,
                                                    out string? subcommand) {
        /* Default output */
        command_name = "";
        subcommand = null;

        string[] parts = command_line.split (" ", 2);

        if (parts.length < 1)
            return null;

        command_name = parts[0];
        if (parts.length == 2 && parts[1] != "")
            subcommand = parts[1];
        else
            subcommand = null;

        /* Extract the first part of the command and see if it matches anything
         * in this.commands */
        return main_client.commands.get (parts[0]);
    }

    [CCode (array_length = false, array_null_terminated = true)]
    private static string[]? readline_completion_cb (string word, int start, int end) {
        /* word is the word to complete, and start and end are its bounds inside
         * Readline.line_buffer, which contains the entire current line. */

        /* Command name completion */
        if (start == 0) {
            return Readline.completion_matches (word, Dcs.Utils.command_name_completion_cb);
        }

        Readline.bind_key ('\t', Readline.abort);

        /* Command parameter completion is passed off to the Command objects */
        string command_name;
        string subcommand;
        Dcs.Command command = Dcs.Client.parse_command_line (Readline.line_buffer,
                                                             out command_name,
                                                             out subcommand);

        if (command != null) {
            if (subcommand == null)
                subcommand = "";
            return command.complete_subcommand (subcommand);
        }

        return null;
    }
}
