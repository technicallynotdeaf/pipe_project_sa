#!/usr/bin/env/ruby

# This file is deprecated, it reads CSV output manually downloaded 
# from the read-hansard-dates scraper

require 'csv'
#require 'ostruct'
require 'enumerator'


class HansardCSVReader
  
  def HansardCSVReader.read_raw_csv(filename)
    

    if File.exists?(filename)
      data = CSV.readlines(filename) 
    else 
      puts "File "+filename+" doesn't exist"
      
    end

    # Ignores comment lines starting with '#'
    data.delete_if {|line| line[0] && line[0][0..0] == '#'}

    data
  end
  
  def HansardCSVReader.read_index(filename)
    data = read_raw_csv(filename)
    data.shift # what does this do?
    data.shift

    data.each do |line|
      date, url, house_of_parl = line[0..2]
      
      filename = ""

      case (house_of_parl)
      when "House of Assembly"
        filename = "xmldata/lower/"
      when "Legislative Council"
        filename = "xmldata/upper/" 
      else
        filename = "xmldata/unknown-"
      end

      filename = filename + date + ".xml"

      puts "Source: " + date + ", " + house_of_parl
      puts "Output file:" + filename
      puts "URL: " + url

      #now attempt to download it... 
#       `curl --output #{filename} #{url}`
      # This doesn't work because that saves the blank HTML page, 
      # not the attached xml content.
    end

  end
  
end

reader = HansardCSVReader.new

csvfilename = "SA_Hansard_index.csv"

HansardCSVReader.read_index(csvfilename)





