import urllib, urllib2, cookielib

username = '1886'
password = 'Pabuji28'

cj = cookielib.CookieJar()
opener = urllib2.build_opener(urllib2.HTTPCookieProcessor(cj))
login_data = urllib.urlencode({'j_username' : username, 'j_password' : password})
resp=opener.open('http://hris:8080/Tejas/login.do', login_data)
print resp.read()
