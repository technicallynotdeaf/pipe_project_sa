#!/bin/ruby

require 'nokogiri'
require 'date'
require_relative 'configuration'


$DEBUG = FALSE
#  I need to class-ify the code structure LOTS MORE!!


def openInputFile (filename)

  Nokogiri::XML(File.open(filename))

end 

def openOutputFile (datestr)

  filename = PIPEConf::SUMMARY_OUTPUT_DIR + datestr + ".php"

  # If the file doesn't exist, put in the header and heading
  if (!File.exists? filename) then
    outputfile = File.open(filename, "w")
    outputfile << "<?php include '../../header.php' ?>"
    outputfile << "\n<h1> Auto-Generated Analysis: #{datestr} </h1>"
    outputfile.close
  end

  File.open(filename, "a")
    
end 

# Main code starts here - generateSummary is called by load_xml_tocs.rb

def generateSummary (full_file_name)

  @doc = openInputFile(full_file_name)
  
  
  #------Identify Date ------------ # 
  
  datetimeStr = @doc.xpath("//date").first.to_s
  
  d = Date.parse(datetimeStr)
  
  datestr = d.strftime('%Y-%m-%d')

  @outputfile = openOutputFile (datestr)

  
  #------Identify House (Upper, lower, estimates...) ------------ # 
  
  house_str = @doc.xpath("//chamber").first.to_s

  # TODO This is where I should check to see whether that house of 
  # parliament has already been summarised to the output file. 
 
  case house_str
  when /House/  # House of Reps is green in parliament
    @outputfile << "\n<div class=\"panel panel-success\" >"
  when /Council/  # Senate is colour coded red
    @outputfile << "\n<div class=\"panel panel-danger\" >"
  else # E.g. estimates committee... grey
    @outputfile << "\n<div class=\"panel panel-default\" >"
  end
  
  @outputfile << "\n<div class=\"panel-heading\">"

  # Create a link to the actual Hansard for the day... 
  saph_filename = File.basename(full_file_name , ".xml")

  date_display_url = "https://hansardpublic.parliament.sa.gov.au/Pages/DateDisplay.aspx#/DateDisplay/"

  @outputfile << "\n<a href=\"#{date_display_url + saph_filename}\">"

  @outputfile << "\n\t<h2> House: #{house_str} </h2>"
  @outputfile << "\n</a>"
  @outputfile << "\n</div>"
  @outputfile << "\n<div class=\"panel-body\" >"
  
  #------Identify Speakers, sort by frequency, output to analysis ----#
 
  @outputfile << "\n<h2> MPs who spoke in #{house_str} </h2>"
  @outputfile << "\n<ul>"
  seen = {}
  
  @doc.xpath("//name").each do |name|
  
    namestr = name.content.to_s
    if !seen[namestr]
      seen[namestr] = 0
    end
    seen[namestr] += 1
  
  end
  
  sorted = seen.sort_by { |name, freq|  -freq }
  
  sorted.each do |name| 
    @outputfile << "\n<li class=\"speaker\"> #{name[0].to_s} \tspoke #{name[1].to_s} times </li>"
  end
  
  @outputfile << "\n</ul>"


  #----Identify Topics, sort by frequency, output to analysis ----#
  
  @outputfile << "\n<h2> Topics Discussed in #{house_str} </h2>"
  @outputfile << "\n<ul>"
  seen = {}
  
  @doc.xpath("//topicinfo").each do |name|
    topicstr = name.content.to_s.strip
  
    # If the topic isn't in the array, add it, then increment listing
    if !seen[topicstr]
      seen[topicstr] = 0
    end
    seen[topicstr] += 1
  end
  
  sorted = seen.sort_by { | topic, freq| -freq}
  
  sorted.each do |topic|
    @outputfile << "\n <li> #{topic[0].to_str} (#{topic[1].to_s} mention/s) </li>"
  
  end
  
  @outputfile << "\n</ul>"
  
  #-------------- Close Output PHP File -------------------# 
 
  @outputfile << "\n</div>" # end panel-body tag
  @outputfile << "\n</div>" # end coloured panel
  @outputfile.close

  File.basename @outputfile # Return output filename

end


# fileWithPath = @inputFileLocation + "2016-11-01/HANSARD-11-24626.xml"

# generateSummary ( fileWithPath )
