import urllib, urllib2, cookielib
#cookie storage
cj = cookielib.CookieJar()
#create an opener
opener = urllib2.build_opener(urllib2.HTTPCookieProcessor(cj))
#Add useragent, sites don't like to interact programs.
opener.addheaders.append(('User-agent', 'Mozilla/4.0'))
opener.addheaders.append( ('Referer', 'http://hris:8080/Tejas/login.do') )
#encode the login data. This will vary from site to site.
#View the sites source code
#Example###############################################
#<form id='loginform' method='post' action='index.php'>
#<div style="text-align: center;">
#Username<br />
#<input type='text' name='user_name' class='textbox' style='width:100px' /><br />
#Password<br />
#<input type='password' name='user_pass' class='textbox' style='width:100px' /><br />
#<input type='checkbox' name='remember_me' value='y' />Remember Me<br /><br />
#<input type='submit' name='login' value='Login' class='button' /><br />
login_data = urllib.urlencode({'j_username' : '1886',
'j_password' : 'Pabuji28',
'Submit' : 'Login'
})
resp = opener.open('http://hris:8080/Tejas/j_acegi_security_check', login_data)
#you are now logged in and can access "members only" content.
#when your all done be sure to close it
print resp.read()
resp.close()

