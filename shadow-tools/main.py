#!/usr/bin/env python
#-*- encoding: UTF-8 -*-

__author__ = "Nicolas Guilloux"
__credits__ = ["Nicolas Guilloux"]
__license__ = "GPL"
__version__ = "1.0.0"
__maintainer__ = "Nicolas Guilloux"
__email__ = "novares.x@gmail.com"
__status__ = "Production"

from checker import *
from fixer import *

# GTK
import gi
gi.require_version('Gtk', '3.0')
from gi.repository import Gtk, Gio

# Post
import urllib.request as urlopen
import urllib.parse

# Locale
import locale
from translation import *

class MainWindow:

    def __init__(self):

        # Builder
        self.builder = Gtk.Builder()

        # Translation
        if "fr" in locale.getlocale()[0]:
            self.trans = frTranslation
            self.builder.add_from_file("gui/layout_fr.glade")

        else:
            self.trans = enTranslation
            self.builder.add_from_file("gui/layout_en.glade")

        # Load window
        self.window = self.builder.get_object("window")

        # Set action for buttons
        button = self.builder.get_object("paste-button")
        button.connect("clicked", self.sendToHastebin)
        button = self.builder.get_object("update-button")
        button.connect("clicked", self.update)

        # Update the view (with empty "button")
        self.update(None)

        self.window.connect("delete-event", Gtk.main_quit)
        Gtk.main()


    ####################### LAYOUTS METHODS #######################

    def vainfoLayout(self):
        # Label
        if len(self.check.vainfo_error) > 0:
            self.setLabelText("vainfo_label", self.trans["vainfo_label_error"])
        else:
            self.setLabelText("vainfo_label", self.trans["vainfo_label_success"])

        # Icons
        if self.check.h264:
            self.setIcon("h264-icon", "object-select-symbolic")
        else:
            self.setIcon("h264-icon", "window-close-symbolic")

        if self.check.h265:
            self.setIcon("h265-icon", "object-select-symbolic")
        else:
            self.setIcon("h265-icon", "window-close-symbolic")

        self.setLabelText("vainfo-str", self.check.vainfo)

    def libLayout(self):
        if len(self.check.missingLib) > 0:
            self.setLabelText("lib-label", self.trans["lib-label_error"])
            self.setLabelText("lib-label2", self.trans["lib-label2_error"])

            str = ""
            for lib in self.check.missingLib:
                str += lib

            self.setLabelText("lib-list", str)

        else:
            self.setLabelText("lib-label", self.trans["lib-label_success"])
            self.setLabelText("lib-list", "")

    def otherLayout(self):
        str = ""

        # Environnement (Xorg)
        env = os.popen("echo $XDG_SESSION_TYPE").read().rstrip()
        if env == "x11":
            str += self.trans["env_success"] + "\n"
        else:
            str += self.trans["env_error"] + env + ". \n"

        # User in input group
        if self.check.input:
            str += self.trans["input_success"]
        else:
            str += self.trans["input_error"]

        self.setLabelText("other-layout", str)

    def logsLayout(self):
        self.setLabelText("logs-label", self.check.logs)

    ####################### PRIVATE METHODS #######################

    def update(self, button):
        # Get information
        self.check = shadowChecker()
        self.fix   = shadowFixer()

        # Layouts
        self.vainfoLayout()
        self.libLayout()
        self.otherLayout()
        self.logsLayout()

        self.window.show_all()

    def setLabelText(self, objectName, text):
        object = self.builder.get_object(objectName)
        object.set_text(text)

        i=2
        object = self.builder.get_object(objectName + str(i))

        while object != None:
            object.set_text(text)
            object = self.builder.get_object(objectName + str(i))
            i += 1


    def setIcon(self, objectName, iconName):
        object = self.builder.get_object(objectName)
        object.set_from_icon_name(iconName, Gtk.IconSize.BUTTON)

        i=2
        object = self.builder.get_object(objectName + str(i))

        while object != None:
            object.set_from_icon_name(iconName, Gtk.IconSize.BUTTON)
            object = self.builder.get_object(objectName + str(i))
            i += 1

    def sendToHastebin(self, other):

        report = self.check.toString()

        file = open("/var/tmp/report_shadow", "w")
        file.write(report)
        file.close()

        key = os.popen("curl -sf --data-binary \"@/var/tmp/report_shadow\" https://hastebin.com/documents | jq .key | sed -e \"s/\\\"//g\"").read().rstrip()
        url = "https://hastebin.com/" + key

        dialog = self.builder.get_object("dialog")
        self.setLabelText("url-label", url)

        dialog.run()
        dialog.destroy()


window = MainWindow()
