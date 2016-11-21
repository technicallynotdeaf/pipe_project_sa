#!/bin/ruby

# To skip to main code, search down to 'webhook' 
# 
# Code written by Alison Keen Nov 2016
# 
# Feel free to appropriate it as you see fit, it's a gift (or curse?)
# depending on how much it is actually helpful vs painful.. 
#

require 'nokogiri'
require 'date'

require_relative 'scraper' # has JSONDownloader class
require_relative 'generate_summary'
require_relative 'email_helper'

$DEBUG = TRUE
$VERBOSE = FALSE

module AK_webhook_helper

  def AK_webhook_helper.are_there_missing_files

    currentyear = Date.today.year

    year = 2007
  
    transcripts_found = 0
  
    json_handler = JSONDownloader.new
  
    json_handler.open_html_output_page()
  
    while year <= currentyear
       transcripts_found += json_handler.download_all_TOCs(year)
       year += 1
    end
  
    json_handler.close_html_output_page()

    result = (json_handler.get_num_transcripts_missing > 0) ? true : false

  end

  def AK_webhook_helper.generate_transcript_summaries

    $source_folder = '/var/www/pipeproject/sa/xmldata/*'
    $dest_folder = '/var/www/pipeproject/sa/summaries/'

    # remove existing files or check for them? 
    # or evn better, pass as an argument? 
    # or better yet, need to create a configuration.rb file... 
    
    Dir[$source_folder].each do |filename|
    
      if ( File.file? filename) then
      
        puts "Input: " + File.basename( filename ) if $VERBOSE
  
        outputFile = generateSummary( filename )

        puts "Output:" + outputFile if $VERBOSE
    
      end #end do-if-is-a-file block
    end #end iterating over filenames

  end



end


# ----------------- Actual webhook code starts here -----------


puts "Checking for missing files..."
puts "Missing Files? " + 
  AK_webhook_helper.are_there_missing_files.to_s if $DEBUG

puts "Generating summaries... "
AK_webhook_helper.generate_transcript_summaries

#emailText = "Summary Generated - #{outputFile}"

#AKEmailHelper.sendMail (emailText)

