import time
from splinter import Browser                
with Browser() as browser: 
  browser.visit("https://oneplus.net/invites?kolid=NXFJB0")
#  browser.execute_script("tabs.open('https://oneplus.net/invites?kolid=NXFJB0');")
body = browser.find_element_by_tag_name("body")
body.send_keys(Keys.CONTROL + 't')
#tabs.open("http://www.example.com");
  browser.fill('invite-email', 'parmilbeniwal1@gmail.com')

  time.sleep( 120 )
#browser.find_by_id('email').find_by_tag('input').fill('parmilbeniwal1@gmail.com')
#  browser.find_by_name('Count me in').click()
#  copied_text = browser.find_by_id('results')[0].text
