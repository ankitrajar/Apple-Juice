from selenium import webdriver
from selenium.webdriver.common.keys import Keys

driver = webdriver.Firefox()
driver.get("https://oneplus.net/invites?kolid=NXFJB0")

body = driver.find_element_by_tag_name("body")
body.send_keys(Keys.CONTROL + 't')
driver.get("https://oneplus.net/invites?kolid=NXFJB0")

body = driver.find_element_by_tag_name("body")
body.send_keys(Keys.CONTROL + 't')

driver.close()
