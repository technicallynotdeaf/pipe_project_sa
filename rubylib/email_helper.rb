#!/bin/ruby

require 'date'      # Used to stamp logfiles
require 'net/smtp'  # so we can send email!!

require_relative 'configuration'

module AKEmailHelper 

  include PIPEConf # so I can use the configuration... 

  # For now, just send an email to the Admin address with this text
  # NB doesn't actually attempt to send email yet, just logs attempt  
  def self.sendAdminMail ( email_body )

    datestr = Time.now.to_s

    emailText = <<MESSAGE_END

From: No Reply <no-reply@pipeproject.info>
To: #{PIPEConf::ADMIN_EMAIL}
MIME-Version: 1.0
Content-type: text/html
Subject: Cuttlefish PIPE email test

#{email_body}
MESSAGE_END

    @outputfile = self.open_log_file ("email.log")
  
    @outputfile << "\n#{datestr} Server: #{PIPEConf::EMAIL_SERVER}"

    @outputfile << "\n#{datestr} Email Text: " + emailText

    @outputfile << "\n ---  \n" # to delineate between records

    @outputfile.close

    puts "Email logged to #{@outputfile.path}"

    File.basename @outputfile # Return output filename

  end


  def self.open_log_file ( filename )

    filename = PIPEConf::LOG_FILE_DIR + filename
    File.open(filename, "a")
  
  end 

end


