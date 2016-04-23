from urllib import urlopen
import urllib2
import urllib
from bs4 import BeautifulSoup
import cookielib
import re
import csv


html = urlopen("https://twittercommunity.com/t/how-to-get-email-from-twitter-user-using-oauthtokens/558/3")
bsObj = BeautifulSoup(html, "lxml")
#data = bsObj.findAll("a", href=re.compile("^(/users/*)"))
data = bsObj.findAll("b", itemprop=re.compile("^(author)"))
csvFile = open("test.csv", 'w+')
try:
	writer = csv.writer(csvFile)
	for dat in data:
		writer.writerow((dat,))

	writer = csv.writer(csvFile)
	for i in range(1):
		writer.writerow( ('Data Scrapped',))
finally:
	csvFile.close()
