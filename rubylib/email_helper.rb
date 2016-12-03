#!/bin/ruby

require 'date'
require_relative 'configuration'

module AKEmailHelper 

  include PIPEConf # so I can use the configuration... 

  # For now, just send an email to the Admin address with this text
  # NB doesn't actually attempt to send email yet, just logs attempt  
  def self.sendAdminMail ( emailText )

    datestr = Time.now.to_s

    @outputfile = self.open_log_file ("email.log")

    puts "Email logged to #{@outputfile.path}"
  
    @outputfile << "\n#{datestr} Email Text: " + emailText

#     server = PIPEConf::EMAIL_SERVER

    @outputfile << "\n#{datestr} Server: #{PIPEConf::EMAIL_SERVER}"

    @outputfile << "\n ---  \n" # to delineate between records

    @outputfile.close

    File.basename @outputfile # Return output filename

  end


  def self.open_log_file ( filename )

    filename = PIPEConf::LOG_FILE_DIR + filename
    File.open(filename, "a")
  
  end 

end


