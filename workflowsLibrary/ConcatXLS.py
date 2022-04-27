import Mistika
from Mistika.classes import  CbaseItem
from Mistika.classes import  Cconnector
from mistikaTools import installModule
try:
    import pandas as pd
    import openpyxl
    import xlwt
except: 
    installModule("pandas")
    installModule("openpyxl")
    installModule("xlwt")
    import pandas as pd

def init(self):
    self.addConnector("xls",Cconnector.CONNECTOR_TYPE_INPUT,Cconnector.MODE_OPTIONAL)
    self.addConnector("xls",Cconnector.CONNECTOR_TYPE_OUTPUT,Cconnector.MODE_OPTIONAL)
    self.addProperty("dstFile")
    return True

def isReady(self):
    res=True
    if not self.dstFile:
        res=self.critical("mergeXLS:dstFile:notFound","Destination Path can not be empty")
    return res

def process(self):
    inputFound=False
    dst=self.evaluate(self.dstFile);
    #create destination File
    #add input files to the destonation file
    all=pd.DataFrame()
    for c in self.getConnectorsByType(Cconnector.CONNECTOR_TYPE_INPUT):
        for p in c.getUniversalPaths():      
            for f in p.getAllFiles():
                inputFound=True
                df = pd.read_excel(f)
                all=all.append(df,ignore_index=True)
    if inputFound:
        writer=pd.ExcelWriter(dst)
        all.to_excel(writer,"mergedData")
        writer.save()
        outputs=self.getConnectorsByType(Cconnector.CONNECTOR_TYPE_OUTPUT)
        out=outputs[0]
        out.setUniversalPathFromString(dst)
    return True