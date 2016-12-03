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
require_relative 'ak_webhook_helper'

require_relative 'configuration'

$DEBUG = TRUE
$VERBOSE = FALSE

puts "Checking for missing files..."
  
if AK_webhook_helper.are_there_missing_files
  puts "Files are missing." if $DEBUG
  line1 = "Hi Admin! \nNew Files Need Downloading. "
  line2 = "Download them here: " 
  line3 = "\n http://sa.pipeproject.info/missing_files.php "
  email_text = line1 + line2 + line3
  subject_line = "Files need downloading."
  AKEmailHelper.send_admin_mail( subject_line, email_text )
#  AKEmailHelper.send_admin_mail(subject_line)

else
  puts "No files missing." if $DEBUG

end

