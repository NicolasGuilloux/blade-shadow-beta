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

class MainWindow:

    def __init__(self):

        # Builder
        self.builder = Gtk.Builder()
        self.builder.add_from_file("gui/layout.glade")

        # Load window
        self.window = self.builder.get_object("window")

        # Set action for buttons
        button = self.builder.get_object("paste-button")
        button.connect("clicked", self.sendToPastebin)
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
            self.setLabelText("vainfo_label", "Votre carte graphique n'est pas correctement détectée. Vérifiez votre driver.")
        else:
            self.setLabelText("vainfo_label", "Votre carte graphique est correctement détectée.")

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
            self.setLabelText("lib-label", "Des librairies sont manquantes. Cliquez sur l'onglet \"Librairies\" pour plus d'informations")
            self.setLabelText("lib-label2", "Les librairies suivantes sont manquantes:")

            str = ""
            for lib in self.check.missingLib:
                str += lib + "\n"

            self.setLabelText("lib-list", str)

        else:
            self.setLabelText("lib-label", "Toutes les librairies nécessaires sont installées.")
            self.setLabelText("lib-list", "")

    def otherLayout(self):
        str = ""

        # Environnement (Xorg)
        env = os.popen("echo $XDG_SESSION_TYPE").read().rstrip()
        if env == "x11":
            str += "Votre environnement est bien sur le serveur Xorg.\n"
        else:
            str += "/!\ Votre environnement n'est pas sur le serveur Xorg (" + env + "), Shadow ne pourra fonctionner. Changez cela pour poursuivre.\n"

        # User in input group
        if self.check.input:
            str += "Utilisateur courant est dans le groupe input"
        else:
            str += "/!\ Utilisateur courant n'est pas dans le groupe input"

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

    def sendToPastebin(self, other):

        data  = os.popen("cat /etc/*-release").read();
        data += os.popen("uname -mrs").read() + "\n";
        data += self.check.toString()

        url = 'http://pastebin.com/api/api_post.php'
        params = {'api_dev_key': '1a8931a5541dd9c7a0a6e15b4920642c','api_option': 'paste','api_paste_code': data}

        from contextlib import closing
        try:
            from urllib.parse import urlencode
            from urllib.request import urlopen
        except ImportError: # Python 2
            from urllib import urlencode
            from urllib2 import urlopen

        data = urlencode(params).encode()
        with closing(urlopen(url, data)) as response:
            url = response.read().decode()

        dialog = self.builder.get_object("dialog")
        self.setLabelText("url-label", url)

        dialog.run()
        dialog.destroy()


window = MainWindow()
