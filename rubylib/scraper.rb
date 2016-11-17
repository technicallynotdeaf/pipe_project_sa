
# Scraper to download SA Hansard XML files using API
# 
# In order to facilitate automatically downloading each day's hansard
# without having to manually download and save each day
# 
# This version of code hacked together by Alison Keen Nov 2016
#
# SA Parliament Hansard API Docs are here: 
# 
# https://parliament-api-docs.readthedocs.io/en/latest/south-australia/#read-data 
#
# Apologies for flagrant violation of coding conventions.
# I think I realised halfway through this one you're supposed to use
# camelCase for variables... oops 

require 'scraperwiki'
require 'json'
require 'fileutils'

# from Hansard server content-type is text/html, attachment is xml

$debug = TRUE
$htmloutput = TRUE
$csvoutput = FALSE
$sqloutput = FALSE

module JSONDownloader

  # The URLs to access the API... 
  @jsonDownloadYearURL = "https://hansardpublic.parliament.sa.gov.au/_vti_bin/Hansard/HansardData.svc/GetYearlyEvents/"

#  @jsonDownloadTocUrl = "https://hansardpublic.parliament.sa.gov.au/_vti_bin/Hansard/HansardData.svc/GetByDate"

#  Manual Download Link: 
  @manual_toc_link = "http://hansardpublic.parliament.sa.gov.au/_layouts/15/Hansard/DownloadHansardFile.ashx?t=tocxml&d="
 

  def JSONDownloader.download_all_TOCs(year) 
  
    #Annual Index is a special case - different API URL  
    annualIndexFilename = downloadAnnualIndex(year)

    get_each_toc_filename(annualIndexFilename) 


      # then we read and load the JSON
      # and request each fragment for each day... 
#       downloadToc(toc_saphFilename) 

      # then get the hash of fragments from each TOC file... 

        # and download each one. 

  end

  # read horrible JSON file and get toc filenames
  def JSONDownloader.get_each_toc_filename(annualIndexFilename)

    transcripts_found = 0

    puts "Parsing annual index #{annualIndexFilename}" if $debug
    rawJSON = File.read(annualIndexFilename)
    loadedJSON = JSON.load rawJSON # Why is this returning a String!?
    parsedJSON = JSON.load loadedJSON # Needs to be parsed twice (!?)

    @outputfile = JSONDownloader.create_html_missing_list()

    parsedJSON.each do |event| # for-each-date
#      puts event.keys if $debug
      record_date =  event['date'].to_s

#      puts "Available for..." + record_date if $debug

      event['Events'].each do |record| # for each transcript on date
#        puts "\nEvent: " + record.to_s if $debug
        saphFilename = record['TocDocId'].to_s.strip
        saphChamber = record['Chamber'].to_s
   

        if !saphFilename.empty? then
          #Output is here: 

#            puts "\"#{saphFilename}\",\"#{record_date}\",\"#{saphChamber}\"" 
          downloaded_filename = "../xmldata/" + saphFilename + ".xml"

          if ( File.exists?(downloaded_filename) ) then 
            puts "#{downloaded_filename} already downloaded." if $debug

            transcripts_found += 1

          else 
#            puts "#{downloaded_filename} not found." if $debug
            toc_download_link = @manual_toc_link + saphFilename
            @outputfile << "\n<p> <a href=\"#{toc_download_link}\">"
            @outputfile << "#{saphFilename} </a> </p>"

          end

        end


      end # end for-each-transcript-on-date block
      
    end # end for-each-date block

    @outputfile.close
    
    transcripts_found #return number of transcripts found

  end

  # Puts the raw, no-line-breaks JSON into a file and
  # returns the file name.
  def JSONDownloader.downloadAnnualIndex(year)

    urlToLoad = @jsonDownloadYearURL + year.to_s
    filename = "downloaded/#{year.to_s}_hansard.json"
    
    puts "downloading file #{filename}" if $debug  
    `curl --silent --output #{filename} "#{urlToLoad}"`
 
    filename # The output of the method. ruby doesn't use 'return'
  end


  def JSONDownloader.create_html_missing_list()
    filename = "/var/www/pipeproject/sa/missing_files.html"
    File.open(filename, "a")
  end

end #end JSONDownloader class

puts "\"Filename\",\"date\",\"house\"" if $csvoutput

currentyear = Date.today.year

year = 2007

transcripts_found = 0;

while year <= currentyear
   transcripts_found += JSONDownloader.download_all_TOCs(year)
   year += 1
end

puts "Transcripts found: " + transcripts_found.to_s



