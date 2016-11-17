#!/bin/ruby

require 'nokogiri'
require 'date'

# not used yet, I need to class-ify the code structure LOTS MORE!!

@inputFileLocation = "/var/www/pipeproject/sa/xmldata/"

@outputFileLocation = "/var/www/pipeproject/sa/summaries/"

def openInputFile (filename)

#  filenameWithPath = @inputFileLocation + filename
  Nokogiri::XML(File.open(filename))

end 

def openOutputFile (datestr)

  filename = @outputFileLocation + datestr + ".html"
  File.open(filename, "a")

end 


def generateSummary (fullFileName)

  @doc = openInputFile(fullFileName)
  
  
  #------Identify Date ------------ # 
  
  datetimeStr = @doc.xpath("//date").first.to_s
  
  d = Date.parse(datetimeStr)
  
  datestr = d.strftime('%Y-%m-%d')

  puts "Date: #{datestr}"
  
  @outputfile = openOutputFile (datestr)
  
  @outputfile << "\n<h1> Basic File Analysis: #{datestr} </h1>"
  
  #------Identify Date ------------ # 
  
  houseStr = @doc.xpath("//chamber").first.to_s
  
  @outputfile <<  "<h2> House: #{houseStr} </h2>"
  
  #------Identify Speakers, sort by frequency, output to analysis ----#
  
  @outputfile << "\n<h2> MPs who spoke in House of Reps </h2>"
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
  
  @outputfile << "\n<h2> Topics Discussed in House of Reps </h2>"
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
  
  @outputfile.close

  File.basename @outputfile # Return output filename

end


# fileWithPath = @inputFileLocation + "2016-11-01/HANSARD-11-24626.xml"

# generateSummary ( fileWithPath )
