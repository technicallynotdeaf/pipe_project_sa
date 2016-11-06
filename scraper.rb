#
#  Scraper to read sitting dates for SA Parliament 
# 
# In order to facilitate automatically downloading each day's hansard
# without having to manually download and save each day
# 
# This version of code hacked together by Alison Keen Oct/Nov 2016
# 
# Initial starting point blatantly plagiarized from 
# 
# https://github.com/openaustralia/example_ruby_phantomjs_scraper/blob/master/scraper.rb
# 
# (Thankyou OpenAustralia people, that's a really helpful example!!)
#

require 'scraperwiki'
require 'capybara'
require 'capybara/poltergeist'


# from Hansard server content-type is text/html, attachment is xml
xml_download_url = "http://hansardpublic.parliament.sa.gov.au/_layouts/15/Hansard/DownloadHansardFile.ashx?t=tocxml&d=HANSARD-10-17452"

fragment_download_url = "https://hansardpublic.parliament.sa.gov.au/_layouts/15/Hansard/DownloadHansardFile.ashx?t=fragment&d=HANSARD-11-24737"
# From own server it sends the file as content-type text/xml, 
# pipe_download_url = "http://sa.pipeproject.info/xmldata/upper/HANSARD-10-17452.xml"

fF_user_agent_string = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.90 Safari/537.36"

$debug = TRUE
$csvoutput = FALSE
$sqloutput = FALSE

capybara = Capybara::Session.new(:poltergeist)

# The Javascript is buggy, we have to ignore errors
# or we get nowhere
capybara.driver.browser.js_errors = false
capybara.driver.headers = { "User-Agent" => fF_user_agent_string }

# Read in the page
capybara.visit(xml_download_url)

puts capybara.status_code
puts capybara.response_headers

# puts page.source

# Read the Legend to find out the dates with data of interest... 
#legend_divs = capybara.all('div.hansard-legend')


# # Write out to the sqlite database using scraperwiki library
# ScraperWiki.save_sqlite(["name"], {"name" => "susan", "occupation" => "software developer"})
