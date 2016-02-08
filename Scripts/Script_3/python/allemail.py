import string
import urllib2
import time

emailList = []
attempts = 0
total = 0
skip = 0
gmailAddress = "parmilkumarbeniwal"
inviteToken = "mytoken"

# def insertDots(str, at):
# 	if at == 0:
# 		emailList.append(str)
# 		return
# 	newStr = str[:at] + "." + str[at:]
# 	if at <= 2:
# 		for i in range(at):
# 			insertDots(newStr, i)

def insertDots(str, max):
	for at in range(max)
	newStr = str[:at] + "." + str[at:]
	if at <= 2:
		for i in range(at):
			insertDots(newStr, i)

def allDots(str):
	for i in range(len(str)):
		insertDots(str, i)

allDots(gmailAddress.replace(".", ""))

total = len(emailList)
# print "Count: {}".format(total)
print "List: "
# print emailList
print

for email in emailList:
	print email
	# attempts += 1
	# if (attempts <= skip):
	# 	continue
	# requestUrl = "https://invites.oneplus.net/index.php?r=share/signup&success_jsonpCallback&email={0}%40gmail.com&koid={1}&_=1438677876942".format(email, inviteToken)
	# print("Sending invite to " + email + "@gmail.com ({}/{}) ...".format(attempts, total))
	# time.sleep(15)
