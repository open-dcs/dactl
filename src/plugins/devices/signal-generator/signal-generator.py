#
# Sample OpenDCS python plugin.
#
# Taken from: https://github.com/gregier/libpeas/tree/master/peas-demo
#
# For gi to find dcs this needs to be run before starting the application:
#   export GI_TYPELIB_PATH=/usr/local/lib/dcs/girepository-1.0/:$GI_TYPELIB_PATH

import gi
gi.require_version('Peas', '1.0')
gi.require_version('DcsCore', '0.2')
gi.require_version('DcsDAQ', '0.2')
gi.require_version('DcsNet', '0.2')
from gi.repository import GObject
from gi.repository import Peas
from gi.repository import DcsCore as Dcs
from gi.repository import DcsDAQ
from gi.repository import DcsNet

from pprint import pprint

LABEL_STRING="Signal Generator Device"

class SignalGenerator(GObject.Object, DcsNet.NetServiceProvider):
    __gtype_name__ = "SignalGenerator"

    service = GObject.property(type=DcsNet.NetService)

    def do_activate(self):
        self.service.test_nothing("Signal Generator device activated")

    def do_deactivate(self):
        self.service.test_nothing("Signal Generator device deactivated")

    def do_start(self):
        self.service.test_nothing(self.__gtype_name__)

    def do_pause(self):
        self.service.test_nothing(self.__gtype_name__)

    def do_stop(self):
        self.service.test_nothing(self.__gtype_name__)

# class SignalGeneratorConfigProvider(GObject.Object, Dcs.ConfigProvider):
    # __gtype_name__ = "SignalGeneratorConfigProvider"

    # config = GObject.property(type=Dcs.Config)

    # def __init__(self):
        # print("Signal Generator configuration provider initialization")
