#!/bin/ruby

require 'date'

module AKEmailHelper

  @@Logfile = "email.log"

  def self.sendMail ( emailText )

    datestr = Time.now.to_s

    @outputfile = openOutputFile (@@Logfile)
  
    @outputfile << "#{datestr} Email Text: " + emailText

    @outputfile << "#{datestr} Link: http://sa.pipeproject.info/missing_files.php"

    @outputfile.close

    File.basename @outputfile # Return output filename

  end


  @outputFileLocation = "/var/www/pipeproject/sa/"

  def openOutputFile ( filename )

    filename = @outputFileLocation + filename
    File.open(filename, "a")
  
  end 

end


