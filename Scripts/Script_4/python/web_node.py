from selenium import webdriver
from selenium.webdriver.common.keys import Keys
import sys

ipaddr = (sys.argv[1])
http_port_no = "20080"

# initiate
driver = webdriver.Firefox() # initiate a driver, in this case Firefox
driver.get('http://'+ipaddr+':'+http_port_no+'/EMSRequest/Welcome') # go to the url

# log in
username_field = driver.find_element_by_name("Username") # get the username field
password_field = driver.find_element_by_name("Password") # get the password field
username_field.send_keys("tejas") # enter in your username
password_field.send_keys("j72e#05t") # enter in your password

submit_field = driver.find_element_by_name("Submit") # get the submit_field
submit_field.send_keys(Keys.RETURN) # Return it


#Kept For Debugging Purpose
#html = driver.page_source
#print html
