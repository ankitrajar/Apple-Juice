import mechanize
import cookielib
from BeautifulSoup import BeautifulSoup
import html2text
import time


import os
hostname = "192.168.143.102" #example
while 1:
    time.sleep(10)
    response = os.system("ping -c 1 " + hostname)
    if response == 0:
        break



# Browser
br = mechanize.Browser()

# Cookie Jar
cj = cookielib.LWPCookieJar()
br.set_cookiejar(cj)

# Browser options
br.set_handle_equiv(True)
br.set_handle_gzip(True)
br.set_handle_redirect(True)
br.set_handle_referer(True)
br.set_handle_robots(False)

# Follows refresh 0 but not hangs on refresh > 0
br.set_handle_refresh(mechanize._http.HTTPRefreshProcessor(), max_time=1)

# User-Agent (this is cheating, ok?)
br.addheaders = [('User-agent', 'Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.1) Gecko/2008071615 Fedora/3.0.1-1.fc9 Firefox/3.0.1')]

# The site we will navigate into, handling it's session
br.open('http://192.168.143.102:20080')

#print br
# Select the first (index zero) form
br.select_form(nr=0)

# User credentials
br.form['Username'] = 'DIAGUSER'
br.form['Password'] = 'j72e#05t'

# Login
br.submit()
req = br.click_link(text='Initialize Node Parameters')
br.open(req)
#print br.response().read()
br.select_form(nr=0)
#print "\n\n\n\n"
#print br.response().read()
br.form['RouterID'] = '192.168.143.102'
br.form['EthernetIPAddress'] = '192.168.143.102'
br.submit()
br.select_form(nr=0)
br.submit()

print br.response().read()
