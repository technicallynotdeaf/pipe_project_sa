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

$DEBUG = FALSE
$VERBOSE = FALSE

# Attempt to clear existing summary files to avoid them being
# endlessly added to... 
# %x( rm #{PIPEConf::SUMMARY_OUTPUT_DIR}*.php )

#puts "Generating summaries... " if $DEBUG
#AK_webhook_helper.generate_transcript_summaries

puts "Sending email.." if $DEBUG

subject_line = "Summaries Generated"
email_text = "Hi! Summaries of all hansard TOC files handy are now up here: http://sa.pipeproject.info/summary_list.php \n Cheers "

AKEmailHelper.send_admin_mail (subject_line, email_text)

