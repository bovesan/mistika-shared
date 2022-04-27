from Mistika.classes import Cconnector
from Mistika.Qt import QColor

mailModulesLoaded=False
try:
    import sys
    import smtplib
    import re
    from email.mime.text import MIMEText
    from email.mime.multipart import MIMEMultipart
    mailModulesLoaded=True
except ImportError,e:
    print "Unable to import modules: "+e.message
    print "check your sys.path "
            
_WF_MAIL_DEFAULT_MSG="""Put your text here
List of Input Files: 
<?py
for c in self.getConnectors():
    for p in c.getUniversalPaths():
      print p.toString()
?>"""

def init(self):
    self.color=QColor(225,225,210)
    self.addConnector("input",Cconnector.CONNECTOR_TYPE_INPUT,Cconnector.MODE_OPTIONAL)
    self.addProperty("login")
    self.addEncryptedProperty("pwd")
    self.addProperty("smtpServer","smtp.gmail.com")
    self.addProperty("port",587)
    self.addProperty("mailFrom")
    self.addProperty("to") #comma separated list
    self.addProperty("subject","Mistika Workflows Mail Node Processed")
    self.addProperty("body",_WF_MAIL_DEFAULT_MSG)
    return True
    
def isReady(self):
    res=True
    if not mailModulesLoaded:
        res=self.critical("mail:modules","Modules not loaded. Check your sys.path or install them")
#    if self.login=="":
#        res=self.critical("mail:loginEmpty","'Login' can not be empty") and res
    if re.match('^(([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,20})\,?)+$',self.to) == None:
        res=self.critical("mail:invalidTo","Invalid email address: "+self.to+". Use ',' to separate multiple mail addresses.") and res
    if self.to=="":
        res=self.critical("mail:toEmpty","'To' can not be empty") and res
    return res
    
def process(self):
    try:
        s = smtplib.SMTP(self.smtpServer,int(self.port))
        try:
            s.starttls()
        except smtplib.SMTPException,e:
             self.warning("process:tls","TLS not supported by server")
        s.ehlo()
        if self.login!="":
            s.login(self.login,self.pwd)
        msg = MIMEMultipart()
        msg['Subject']=self.evaluate(self.subject)
        f=self.mailFrom.strip()
        msg['From']=f if len(f)>0 else self.login
        msg['To']=self.to
        body=self.evaluate(self.body)
        msg.attach(MIMEText(body.encode("utf8"),'plain'))
        s.sendmail(self.login,self.to.split(","),msg.as_string())
        s.quit()
    except Exception,e:
        return self.critical("process:smtp",u"smtp Error: {}".format(e))
    return True


