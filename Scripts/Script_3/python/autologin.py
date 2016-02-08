from __future__ import absolute_import
import cookielib
import urllib2, urllib, urlparse
import urllib2, urllib
import urllib2, urllib
import urllib2, urllib
import urllib2, urllib, urlparse
import urllib2, urllib
import sys

script_name = (sys.argv[0])
totalargs = len(sys.argv)
if totalargs != 2:
	print u"Usages: %s ip" % script_name
	sys.exit(0)
ipaddr = (sys.argv[1])
http_port_no = "20080"

cj = cookielib.CookieJar()
opener = urllib2.build_opener(urllib2.HTTPCookieProcessor(cj))
opener.open(u'http://'+ipaddr+':'+http_port_no+'/EMSRequest/Welcome')
opener.addheaders.append((u'User-agent', u'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:37.0) Gecko/20100101 Firefox/10.0.1'))
opener.addheaders.append( (u'Referer', u'http://'+ipaddr+':'+http_port_no+'/EMSRequest/Welcome') )
#Username=DIAGUSER&Password=j72e%2305t&Domain=1&Submit=Submit
login_data = urllib.urlencode({
u'Username' : u'DIAGUSER',
u'Password' : u"j72e#05t",
u'Domain' : u'1',
u'Submit' : u'Submit',
})
binary_data = login_data.encode(u'ascii')
opener.open(u'http://'+ipaddr+':'+http_port_no+'/EMSRequest/Welcome', binary_data)

#######Different URL Strings#########
base_URL = 'http://'+ipaddr+':'+http_port_no
nodeInventory_URL = base_URL + '/EMSRequest/nodeInventory?'
cardInfo_URL = base_URL + '/EMSRequest/cardInfo'
nodeBody_URL = base_URL + '/EMSRequest/nodeBody?'
print "\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"

resp = opener.open(nodeBody_URL)
print resp.read()
resp.close()
print "\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
print "\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"

resp = opener.open(nodeInventory_URL)
print resp.read()
resp.close()
print "\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
print "\n++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"
resp = opener.open(cardInfo_URL)
print resp.read()
resp.close()

#resp = opener.open(base_URL + '/EMSRequest/L2InterfaceParams?serviceSwitch=ServiceSwitch-0-0-11')
#print resp.read()
#resp.close()
