#-*- encoding: UTF-8 -*-
# from functions import *
from shadow import *

import gi
gi.require_version('Gtk', '3.0')

from gi.repository import Gtk, Gio
import urllib.request as urlopen
import urllib.parse

class MainWindow(Gtk.Window):

    def __init__(self):
        self.shadow = shadow()

        Gtk.Window.__init__(self, title="Outil de diagnostique - Shadow")
        self.set_border_width(10)
        self.set_default_size(800, 400)

        # Set icon
        self.set_icon( Gtk.IconTheme.get_default().load_icon("shadow-beta", 64, 0) )

        # Header
        self.buildHeader()

        # Container
        self.notebook = Gtk.Notebook()
        self.add(self.notebook)

        # Layout
        self.summaryLayout()
        self.vainfoLayout()
        # self.libLayout()

        self.connect("delete-event", Gtk.main_quit)
        self.show_all()
        Gtk.main()

    def buildHeader(self):
        hb = Gtk.HeaderBar()
        hb.set_show_close_button(True)
        hb.props.title = "Outil de diagnostique"
        self.set_titlebar(hb)

        button = Gtk.Button()
        # icon = Gio.ThemedIcon(name="go-up")
        # image = Gtk.Image.new_from_gicon(icon, Gtk.IconSize.BUTTON)
        # button.add(image)
        button.connect("clicked", self.sendToPastebin)
        button.set_label("Pastebin")
        hb.pack_end(button)

    def summaryLayout(self):
        page = Gtk.Box()
        page.set_border_width(10)
        page.add(Gtk.Label('Default Page!'))
        self.notebook.append_page(page, Gtk.Label('Résumé'))

    def vainfoLayout(self):

        page = Gtk.Box()
        page.set_border_width(10)

        if len(self.shadow.check.vainfo_error) > 0:
            label = Gtk.Label("Votre vainfo présente des erreurs : " + self.shadow.check.vainfo_error)
            page.add(label)

        else:
            label = Gtk.Label("Votre vainfo semble être bon.")
            page.add(label)

            label = Gtk.Label("H264")
            page.add(label)

            if self.shadow.check.h264:
                icon = Gtk.Image.new_from_gicon( Gio.ThemedIcon(name="object-select-symbolic") , Gtk.IconSize.BUTTON)
            else:
                icon = Gtk.Image.new_from_gicon( Gio.ThemedIcon(name="window-close-symbolic") , Gtk.IconSize.BUTTON)
            page.add(icon)

            # label = Gtk.Label("H265")
            # self.grid.attach(label, 2, 1, 1, 1)
            #
            # if self.shadow.check.h265:
            #     icon = Gtk.Image.new_from_gicon( Gio.ThemedIcon(name="go-up") , Gtk.IconSize.BUTTON)
            # else:
            #     icon = Gtk.Image.new_from_gicon( Gio.ThemedIcon(name="go-down") , Gtk.IconSize.BUTTON)
            # self.grid.attach(icon, 3, 1, 1, 1)

        self.notebook.append_page(page, Gtk.Label('Carte Graphique'))

    def libLayout(self):
        frame = Gtk.Frame()
        self.grid.attach(frame, 4, 0, 5, 6)

        if len(self.shadow.check.missingLib) > 0:
            str = "Il y a des librairies manquantes :"
            for lib in self.shadow.check.missingLib:
                str += "\n" + lib

            label = Gtk.Label(str)
            frame.add(label)
        else:
            label = Gtk.Label("Toutes les librairies sont correctement installées.")
            frame.add(label)

    def otherLayout(self):
        frame = Gtk.Frame()
        self.grid.attach(frame, 10, 0, 5, 6)

        if self.shadow.check.input:
            str = "L'utilisateur courant est bien dans le groupe input."
        else:
            str = "/!\ L'utilisateur courant n'est pas dans le groupe input !"

        label = Gtk.Label(str)
        frame.add(label)

        label = Gtk.Label("Type d'environnement: " + os.popen("echo $XDG_SESSION_TYPE").read())
        frame.add(label)

    def sendToPastebin(self, other):

        data  = os.popen("cat /etc/*-release").read();
        data += os.popen("uname -mrs").read() + "\n";
        data += self.shadow.check.toString()
        print(data)

        url = 'http://pastebin.com/api/api_post.php'
        params = {'api_dev_key':'1a8931a5541dd9c7a0a6e15b4920642c','api_option':'paste','api_paste_code':data}

        from contextlib import closing
        try:
            from urllib.parse import urlencode
            from urllib.request import urlopen
        except ImportError: # Python 2
            from urllib import urlencode
            from urllib2 import urlopen

        # data = urlencode(params).encode()
        # with closing(urlopen(url, data)) as response:
        #     url = response.read().decode()
        #
        # return url

window = MainWindow()
