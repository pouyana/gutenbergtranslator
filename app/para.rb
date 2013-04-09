#!/usr/bin/ruby

file = open("helpers/gut.text")
paragString=""
counter=0
paragraphs = Array.new
file.each_line{|line|
  counter=counter+1
  if(/\n/.match(line.to_s) and line.length>2)
  paragString=paragString+line.to_s
  else
  paragraphs.push(paragString)
#  puts counter.to_s+" "+ paragString
  paragString=""
  end
}
puts paragraphs.length.to_s+"\n"
puts counter
