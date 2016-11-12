#!/bin/sh


# Date 
cat $1 | grep \<date

echo "Topics that got a mention:"
# Discussed Topics
cat $1 | grep \<text | sort | sed 's/  //g' | uniq -c | sort -rn | grep -v ">Question" | grep -v ">Papers" | grep -v "Second Reading" | grep -v "Bills" | grep -v "Parliamentary Procedure" | grep -v "Ministerial Statement" | sed 's/<text>//g' | sed 's/<\/text>//g'

echo "People who spoke: " 
# Chatty Members
cat $1 | grep \<name | sort | sed 's/  //g' | uniq -c | sort -rn | sed 's/<name>//g' | sed 's/<\/name>//g'
