# 
# To use this file, rename to configuration.rb
# 
# I just wanted an easy conf object that didn't need parsing out of
# a markup file, but needs to be excludable from git repo so that 
# cuttlefish passwords etc weren't world-shared. 
# 
# Also handy to use for updating different directories where stuff
# is read from and stored to, probably good as a reference for anyone
# trying to read along from home... 
# 
 


module PIPEConf

  # Login details for Cuttlefish... 
  EMAIL_SERVER = "cuttlefish.oaf.org.au"
  EMAIL_PORT = 2525
  SENDING_DOMAIN = "your-domain.com"
  USERNAME = "xxxxxxxxx"
  PASSWORD = "xxxxxxxxx"
  AUTHTYPE = "plain"

  ADMIN_EMAIL = "you@domain.com"
  FROM_ADDRESS = "no-reply@your-domain.com"

  # these are where I have them on my server, change as appropriate
  LOG_FILE_DIR = "/var/www/pipeproject/sa/logs/"

  # Where have you put the XML files you want to summarise?
  # nb parser currently (dec 2016) just reads "topic" and "name" tags
  # from the XML and slices and dices into a sorted de-dup'd list
  XML_TOC_DIR = "/var/www/pipeproject/sa/xmldata/"

  # This is where the ruby scripts output the generated summaries
  # for the XML files found in the above folder
  SUMMARY_OUTPUT_DIR = "/var/www/pipeproject/sa/summaries/"


end
