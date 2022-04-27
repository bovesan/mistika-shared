# v 0.4 bug fixed. not detecting remaining size correctly
# v 0.3 P8 classes extracted to lib/panasonic8K
# v 0.2 
# tesst only mode added
# repeated names check added
#v 0.1 initial draft

import os
import distutils
from distutils import dir_util
import shutil
import sys
from Mistika.classes import Cconnector
from Mistika.classes import CuniversalPath

import panasonic8K
from panasonic8K import Cp2CardCopier
    
def init(self):
    self.addProperty("dstPath")
    self.addProperty("cardName","p2Card")
    self.addProperty("cardSize",32)
    self.addProperty("mode",Cp2CardCopier.MODE_COPY) #0=move, 1=copy
    self.addConnector("p8",Cconnector.CONNECTOR_TYPE_INPUT,Cconnector.MODE_OPTIONAL)
    self.addConnector("out",Cconnector.CONNECTOR_TYPE_OUTPUT,Cconnector.MODE_OPTIONAL)
    self.setAcceptConnectors(True,"p8")
    return True

def isReady(self):
    res=True
    dst=self.evaluate(self.dstPath)
    if dst=="":
        res=self.critical("joinP8contents:isReady:dst","'dstPath' can not be empty") and res
    if not os.path.isdir(dst):
        res=self.critical("joinP8contents:isReady:notDIr",u"'dstPath' {} is not a directory".format(dst)) and res
    return res

def process(self):
    res=True
    dstFolder=self.evaluate(self.dstPath)
    cardName=self.evaluate(self.cardName)
    mode=int(self.mode)
    size=int(self.cardSize)
    copier=Cp2CardCopier(self,None)
    self.progressUpdated(0) 
    inputList=copier.getInputList()
    sz=len(inputList)
    out=self.getFirstConnectorByName("out")
    out.clearUniversalPaths()
    while res and sz>0:
        root,cards=copier.getNextCardFolderAvailable(dstFolder,cardName,size,mode!=Cp2CardCopier.MODE_TRACE_ONLY)
        self.info("joinP8contents:process:root","creating p2 tree "+root)
        res,inputList,processedList=copier.transfer(inputList,cards) 
        for x in processedList:
            fp=x.getFilePath()            
            x.reroot(dstFolder) 
            pos=fp.rfind("/exP2-")
            if pos<0:
                pos=fp.rfind("/mP2/")           
            if pos>=0:
                fp=root+fp[pos:]
            x.setFilePath(fp)           
            out.addUniversalPath(x)
        newsz=len(inputList)
        if newsz==sz:
            res=self.critical("joinP8contents:process:end","Unable to copy more files") and res
        else:
            sz=newsz
    return res