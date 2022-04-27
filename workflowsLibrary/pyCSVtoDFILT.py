import Mistika
import csv
from Mistika.classes import Cconnector
from Mistika.classes import CuniversalPath
from Mistika.Qt import QColor

def init(self):    
    self.color=QColor("#94b4f2")
    self.addProperty("delimiter",",")
    self.addProperty("headerDefault","MISTIKA WATERMARK")
    self.addProperty("bodyDefault","body Text body Text")
    self.addProperty("footerDefault","footer line")
    self.addConnector("csv",Cconnector.CONNECTOR_TYPE_INPUT,Cconnector.MODE_OPTIONAL)
    self.addConnector("files",Cconnector.CONNECTOR_TYPE_OUTPUT,Cconnector.MODE_OPTIONAL)
    return True

def isReady(self):
    res=True
    if self.delimiter=="":
        res=self.critical("CSVtoDFILT:delimiter","'Delimiter can not be empty")
    return res

def process(self):   
       
    def processOneCSV(up,output):
        filename=up.getFilePath()
        self.info('CSVtoDFILT:processOneCSV',u'Processing CSV {}'.format(filename))
        with open(filename) as f:
            reader = csv.reader(f, delimiter=self.delimiter.encode('ascii','ignore'))
            try:
                for line in reader:
                    dst=CuniversalPath(self.getNameConvention())
                    dst.autoFromName(line[0])
                    data={}
                    data["header.text"]=line[1].encode('utf-8','ignore') if line[1]!="" else self.headerDefault
                    data["body.text"]=line[2].encode('utf-8','ignore') if line[2]!="" else self.bodyDefault
                    data["footer.text"]=line[3].encode('utf-8','ignore') if line[3]!="" else self.footerDefault
                    dst.setPrivateData("CurvesData",data)
                    output.addUniversalPath(dst)      
            except csv.Error as e:
                return self.critical('CSVtoDFILT:CSVerror',u'file {}, line {}: {}'.format(filename, reader.line_num, e))
        return True
        
    res=True  
    input=self.getFirstConnectorByName("csv")
    output=self.getFirstConnectorByName("files")
    output.clearUniversalPaths ()
    list=input.getUniversalPaths()
    for up in list:
            res=res and processOneCSV(up,output) 
    return res