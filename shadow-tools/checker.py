#-*- encoding: UTF-8 -*-
import os
import textwrap

class shadowChecker:

    def __init__(self):
        self.pathExec = "/opt/shadowbeta/shadow-beta"
        self.pathClientSDL = "/opt/shadowbeta/resources/app.asar.unpacked/native/linux/Shadow"
        self.pathLogs = "/home/" + os.popen("echo $USER").read().rstrip() + "/.cache/blade/shadow/shadow.log"

        self.vainfo()
        self.libraries()
        self.input()
        self.logs()

    ### Vainfo
    def vainfo(self):
        # Init
        self.vainfo = ""
        self.vainfo_error = ""
        self.h264 = False
        self.h265 = False

        self.vainfo = os.popen("vainfo").read()

        if "returns -1" in self.vainfo:
            self.vainfo_error = "Carte graphique mal reconnue"
            return

        if "H264" in self.vainfo:
            self.h264 = True

        if ("H265" in self.vainfo) or ("HEVC" in self.vainfo):
            self.h265 = True

    ### Dependencies
    def libraries(self):
        self.missingLib = []

        mlib = os.popen("ldd -v " + self.pathExec + " | grep \"not found\"")
        self.missingLib += mlib.readlines()

        mlib = os.popen("ldd -v " + self.pathClientSDL + " | grep \"not found\"")
        self.missingLib += mlib.readlines()

    ### User in input
    def input(self):
        res = os.popen("groups $USER | grep input").readlines()

        if len(res) > 0:
            self.input = True

        else:
            self.input = False

    ### Logs
    def logs(self):
        self.logs = ""

        if os.path.exists(self.pathLogs):
            file = open(self.pathLogs, "r")
            tmpLogs = file.readlines()
            file.close()

            index = self.index_containing_substring( list(reversed(tmpLogs)), "template_digit")
            self.logs = "".join( tmpLogs[len(tmpLogs)-index-1:] )

        else:
            self.logs = "Aucun fichier de logs trouvé. Essayez de lancer le stream avant.\nSi le problème persiste, c'est que le stream crash avant d'avoir pu créer des logs.\n\nContactez la communauté Discord pour avoir plus d'informations. \nhttps://discordapp.com/invite/shadowtech"

    ## toString
    def toString(self):

        str  = os.popen("cat /etc/*-release").read()
        str += os.popen("uname -mrs").read() + "\n"

        str += "-------------------------------------\n\n"

        str += "Type d'environnement: " + os.popen("echo $XDG_SESSION_TYPE").read()
        if self.input:
            str += "Utilisateur courant est dans le groupe input\n\n"
        else:
            str += "/!\ Utilisateur courant n'est pas dans le groupe input\n\n"

        str += "-------------------------------------\n"
        str += "       Librairies manquantes\n"
        str += "-------------------------------------\n"

        for lib in self.missingLib:
            str += textwrap.dedent( lib.rstrip().rstrip("  ") ) + "\n"
        str += "\n\n"

        str += "-------------------------------------\n"
        str += "               Vainfo\n"
        str += "-------------------------------------\n"
        str += self.vainfo

        str += "-------------------------------------\n"
        str += "                Logs\n"
        str += "-------------------------------------\n"
        str += self.logs

        return str

    def index_containing_substring(self, the_list, substring):
        for i, s in enumerate(the_list):
            if substring in s:
                  return i
        return -1
