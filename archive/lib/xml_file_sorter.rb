#!/usr/bin/env/ruby

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
      date, orig_filename, house_of_parl = line[0..2]

      orig_filename = "xmldata/" + orig_filename + ".xml"
      
      if File.exists?(orig_filename)
          
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
  
        puts "Found: " + date + ", " + house_of_parl
        puts "Output file:" + filename
      else
        puts "Missing File: " + orig_filename
        puts "Missing File: " + date + ", " + house_of_parl
      end

    end

  end
  
end

reader = HansardCSVReader.new

csvfilename = "SA_Hansard_index.csv"

HansardCSVReader.read_index(csvfilename)





