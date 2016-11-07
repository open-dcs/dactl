#
# Sample OpenDCS python plugin.
#
# Taken from: https://github.com/gregier/libpeas/tree/master/peas-demo
#
# For gi to find dcs this needs to be run before starting the application:
#   export GI_TYPELIB_PATH=/usr/local/lib/girepository-1.0/:$GI_TYPELIB_PATH

import gi
gi.require_version('Gtk', '3.0')
gi.require_version('Peas', '1.0')
gi.require_version('PeasGtk', '1.0')
gi.require_version('DcsCore', '0.1')
gi.require_version('DcsUI', '0.1')
from gi.repository import GObject
from gi.repository import Gtk
from gi.repository import Peas
from gi.repository import PeasGtk
from gi.repository import DcsCore
from gi.repository import DcsUI

LABEL_STRING="Python Plugin Sample"

class PythonPlugin(GObject.Object, Peas.Activatable):
    __gtype_name__ = 'PythonPlugin'

    # view = GObject.Property(type=DcsCore.ApplicationView)
    object = GObject.property(type=GObject.Object)

    def do_activate(self):
        print("PythonPlugin.do_activate")
        self.button = Gtk.Button(label="Quit")
        self.button.connect("clicked", Gtk.main_quit)
        self.app = self.object.app
        self.app.controller.add(self.button, "/win0/pg0")
        self.button.show()
        # window._python_label = Gtk.Label()
        # window._python_label.set_text(LABEL_STRING)
        # window._python_label.show()
        # window.get_child().pack_start(window._python_label, True, True, 0)

    def do_deactivate(self):
        print("PythonPlugin.do_deactivate")
        self.app.remove("/win0/pg0/box0")
        # window.get_child().remove(window._python_label)
        # window._python_label.destroy()

    def do_update_state(self):
        print("PythonPlugin.do_update_state")

class PythonConfigurable(GObject.Object, PeasGtk.Configurable):
    __gtype_name__ = 'PythonConfigurable'

    def do_create_configure_widget(self):
        return Gtk.Label.new("Python plugin configure widget")
