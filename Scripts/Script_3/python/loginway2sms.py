import urllib, urllib2, cookielib
#cookie storage
cj = cookielib.CookieJar()
#create an opener
opener = urllib2.build_opener(urllib2.HTTPCookieProcessor(cj))
#Add useragent, sites don't like to interact programs.
opener.addheaders.append(('User-agent', 'Mozilla/4.0'))
opener.addheaders.append( ('Referer', 'http://site21.way2sms.com/entry?ec=0080&id=86pq') )
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
login_data = urllib.urlencode({'username' : '8123737674',
'password' : 'tilluchimpu',
#'Submit' : 'Login'
})
resp = opener.open('http://site21.way2sms.com/Login1.action', login_data)
#you are now logged in and can access "members only" content.
#when your all done be sure to close it
print resp.read()
resp.close()

