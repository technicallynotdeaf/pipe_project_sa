#!/bin/ruby

require 'nokogiri'
require 'date'

require_relative 'generate_summary'
require_relative 'email_helper'

fileWithPath = "lower/2016-11-01/HANSARD-11-24626.xml"

$folder = '/var/www/pipeproject/sa/xmldata/*'

Dir[$folder].each do |filename|

  if ( File.file? filename) then

    puts "Input: " + File.basename( filename )

    outputFile = generateSummary( filename )
    puts "Output:" + outputFile

  end #end do-if-is-a-file block

end #end iterating over filenames


#emailText = "Summary Generated - #{outputFile}"

#AKEmailHelper.sendMail (emailText)
