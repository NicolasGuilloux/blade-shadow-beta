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

check = shadowChecker()
print( check.toString() )
