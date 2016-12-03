#!/bin/ruby

# 
# Note to self: Contribute back to Cuttlefish.io docs for anyone else
# by pulling mlandauer/cuttlefish and cloning...
# 
# https://github.com/mlandauer/cuttlefish/blob/master/app/views/documentation/_rails.html.haml
#
#

require 'date'      # Used to stamp logfiles
require 'net/smtp'  # so we can send email!!

require_relative 'configuration'

module AKEmailHelper 

  include PIPEConf # so I can use the configuration... 

  # For now, just send an email to the Admin address with this text
  # NB doesn't actually attempt to send email yet, just logs attempt  
  def self.send_admin_mail( subject_line, email_body )

    datestr = Time.now.to_s

    email_text = <<MESSAGE_END

From: #{PIPEConf::FROM_NAME} <#{PIPEConf::FROM_ADDRESS}>
To: #{PIPEConf::ADMIN_EMAIL}
MIME-Version: 1.0
Content-type: text/html
Subject: #{subject_line}

#{email_body}
MESSAGE_END


    smtp = Net::SMTP.new(
      PIPEConf::EMAIL_SERVER, 
      PIPEConf::EMAIL_PORT, 
    ) 

    # Despite using :plain auth, Cuttlefish.io requires STARTTLS 
    # Need this Or Else smtp.start throws 550 Auth Error
    # can't call this on Net::SMTP because needs to be set before start
    smtp.enable_starttls_auto

    smtp.start(
      PIPEConf::EMAIL_SERVER,
      PIPEConf::USERNAME,
      PIPEConf::PASSWORD,
      :plain
    )

    smtp.send_message  email_text, 
      PIPEConf::FROM_ADDRESS, 
      PIPEConf::ADMIN_EMAIL

    smtp.finish
 
    @outputfile = self.open_log_file ("email.log")
  
    @outputfile << "\n#{datestr} Server: #{PIPEConf::EMAIL_SERVER}"

    @outputfile << "\n#{datestr} Email Text: " + email_text

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


