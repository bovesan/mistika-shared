#autoexec.py
#This file is automatically exacuted during launch time
import site
import sys
import os

sys.argv=['']
if not sys.exec_prefix:
    print('python not found. Please define PYTHONHOME variable')

import Mistika
scriptsPath=os.path.normpath(Mistika.sgoPaths.scripts())
libPath=os.path.normpath(Mistika.sgoPaths.workflowsLibrary())
sys.path.insert(0,os.path.join(libPath,"lib"))
sys.path.insert(0,scriptsPath)
import mistikaTools

online=mistikaTools.hasInternetConnection()
ok=mistikaTools.installPythonModules(online)
if not ok:
    #warning
    if not online:
        w=Mistika.QtGui.QMessageBox(Mistika.QtGui.QMessageBox.Warning,"Unable to install required Modules", "Python was unable to install required Modules.\nPlease check your internet connection")
    else:    
        w=Mistika.QtGui.QMessageBox(Mistika.QtGui.QMessageBox.Warning,"Unable to install required Modules", "Python was unable to install required Modules.\nPlease check your python installation")
    w.show()

#add here your initialization code

print "autoexec.py loaded"
