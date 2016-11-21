
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

$debug = FALSE
$csvoutput = FALSE
$sqloutput = FALSE

class JSONDownloader

  # The URLs to access the API... 

#  @jsonDownloadTocUrl = "https://hansardpublic.parliament.sa.gov.au/_vti_bin/Hansard/HansardData.svc/GetByDate"

  def initialize
    @total_found_transcripts = 0
    @total_missing_transcripts = 0
  end 

  def download_all_TOCs(year) 
  
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
  def get_each_toc_filename(annualIndexFilename)

    #  Manual Download Link: 
    @manual_toc_link = "http://hansardpublic.parliament.sa.gov.au/_layouts/15/Hansard/DownloadHansardFile.ashx?t=tocxml&d="

    @transcripts_found = 0
    @transcripts_missing = 0

    puts "Parsing annual index #{annualIndexFilename}" if $debug
    rawJSON = File.read(annualIndexFilename)
    loadedJSON = JSON.load rawJSON # Why is this returning a String!?
    parsedJSON = JSON.load loadedJSON # Needs to be parsed twice (!?)


#    @outputfile << "\n<div class=\"col-sm-4\">"

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
#            puts "#{downloaded_filename} already downloaded." if $debug

            @transcripts_found += 1

          else 
            @transcripts_missing += 1
#            puts "#{downloaded_filename} not found." if $debug
            toc_download_link = @manual_toc_link + saphFilename
            @outputfile << "\n<div class=\"alert alert-warning\" role =\"alert\">"
            @outputfile << "\n<p> <a href=\"#{toc_download_link}\">"
            @outputfile << "<strong>Missing: </strong> #{saphFilename}"
            @outputfile << " </a>(#{record_date} - #{saphChamber})</p>"
            @outputfile << "\n</div>"

          end

        end


      end # end for-each-transcript-on-date block
      
    end # end for-each-date block

    if ( @transcripts_missing == 0 ) then
      @outputfile << "\n<h4> No Transcripts missing from "
      @outputfile << "#{annualIndexFilename} </h4>"
    end

#    @outputfile << "\n</div>" #end col-sm-4

    @total_missing_transcripts += @transcripts_missing
    @total_found_transcripts += @transcripts_found

    @transcripts_found #return number of transcripts found

  end

  def get_num_transcripts_found
    @total_found_transcripts
  end
 
  def get_num_transcripts_missing
    @total_missing_transcripts
  end

  # Puts the raw, no-line-breaks JSON into a file and
  # returns the file name.
  def downloadAnnualIndex(year)

    @jsonDownloadYearURL = "https://hansardpublic.parliament.sa.gov.au/_vti_bin/Hansard/HansardData.svc/GetYearlyEvents/"
    
    warn 'nil year supplied?' if(year == NIL) 

    urlToLoad = @jsonDownloadYearURL + year.to_s
    filename = "downloaded/#{year.to_s}_hansard.json"
    
    puts "downloading file #{filename}" if $debug  
    `curl --silent --output #{filename} "#{urlToLoad}"`
 
    filename # The output of the method. ruby doesn't use 'return'
  end


  def open_html_output_page()
    filename = "/var/www/pipeproject/sa/missing_files.php"
    @outputfile = File.open(filename, "w")
    @outputfile << "\n<?php include \'../header.php\' ?>"
    @outputfile << "\n<div class=\"container\">"
    @outputfile << "\n<div class=\"row\">"
  end

  def close_html_output_page()
    @outputfile << "\n</div></div>"
    @outputfile << "\n<?php include \'../footer.php\' ?>"
    @outputfile.close
  end
    
end #end JSONDownloader class

# puts "\"Filename\",\"date\",\"house\"" if $csvoutput

# currentyear = Date.today.year

# year = 2007

# transcripts_found = 0

# downloader = JSONDownloader.new

# downloader.open_html_output_page()
# 
# while year <= currentyear
#    transcripts_found += downloader.download_all_TOCs(year)
#    year += 1
# end
# 
# downloader.close_html_output_page()
# 
# puts "Transcripts found: " + transcripts_found.to_s
# 
# puts "Files missing: " + downloader.get_num_transcripts_missing.to_s

