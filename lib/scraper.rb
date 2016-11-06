#
#  Scraper to download Hansard transcript xml files
# 
# In order to facilitate automatically downloading each day's hansard
# without having to manually download and save each day
# 
# This version of code hacked together by Alison Keen Oct/Nov 2016
# 
# Credit where Credit is due: 
# Lots of help from OpenAustralia people, especially @henare and @wfdd
# How to use capybara/selenium to download attachments: 
# http://collectiveidea.com/blog/archives/2012/01/27/testing-file-downloads-with-capybara-and-chromedriver/
#

# Stuck. 
# 
# Sticking point #1, the collectiveidea.com example includes the helper
# class but doesn't show how to actually use it
# 
# Sticking point #2, I don't know enough Ruby to know if I have
# defined XMLFileGrabber as a static class or an instantiable one
# 
# Therefore I can't work out how to create a function that will
# do the work of loading a URL and catching the downloaded file. 
# 

require 'scraperwiki'
require 'capybara'
# require 'capybara/poltergeist'
require 'selenium/webdriver'
require './downloads'

# From own server it sends the file as content-type text/xml, 
# pipe_download_url = "http://sa.pipeproject.info/xmldata/upper/HANSARD-10-17452.xml"


$debug = TRUE
$csvoutput = FALSE
$sqloutput = FALSE


class XMLFileGrabber 

# from Hansard server content-type is text/html, attachment is xml
#  @xml_download_url = "http://hansardpublic.parliament.sa.gov.au/_layouts/15/Hansard/DownloadHansardFile.ashx?t=tocxml&d=HANSARD-10-17452"
  @xml_download_url = "http://hansardpublic.parliament.sa.gov.au/_layouts/15/Hansard/DownloadHansardFile.ashx?t=tocxml&d="

  @fragment_download_url = "https://hansardpublic.parliament.sa.gov.au/_layouts/15/Hansard/DownloadHansardFile.ashx?t=fragment&d=HANSARD-11-24737"

  @user_agent_string = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.90 Safari/537.36"

  def initialize 
    Capybara.register_driver :chrome do |app|
      profile = Selenium::WebDriver::Chrome::Profile.new
      profile["download.default_directory"] = DownloadHelpers::PATH.to_s
      Capybara::Selenium::Driver.new(app, :browser => :chrome, :profile => profile)

      Capybara.default_driver = Capybara.javascript_driver = :chrome

    end

    @session = Capybara::Session.new
  end

  def ready
    # Read in the page
    @session.driver.headers = { "User-Agent" => @user_agent_string }
    yield(@session)
  end

  def grabfile(toc_filename)

    # compile download link
    url = @xml_download_url + toc_filename
    # Read in the page
    puts "Attemted download: " + url
    @session.visit(url)
    DownloadHelpers::download_content
    DownloadHelpers::wait_for_download
    yield(@session)

  end


end

XMLFileGrabber.new.ready do |capybara|



# Read in the page

puts capybara.status_code
puts capybara.response_headers

# puts page.source

# Read the Legend to find out the dates with data of interest... 
#legend_divs = capybara.all('div.hansard-legend')


# # Write out to the sqlite database using scraperwiki library
# ScraperWiki.save_sqlite(["name"], {"name" => "susan", "occupation" => "software developer"})
