#!/usr/local/bin/ruby
require "open-uri"

#the gutenberg text info class
class GutenbergText
  attr_accessor :gutenberg, :licence, :ebook_number , :title, :author, :illustrator, :release_date, :lang, :charset,:size

  def initilize(gutenberg,licence,ebook_number,title,author,illustrator,release_date,lang,charset,size)
      @gutenberg  = gutenberg
      @licence = licence
      @ebook_number = ebook_number
      @title = title
      @author = author
      @illustrator = illustrator
      @relase_date = release_date
      @lang = lang
      @charset = charset
      @size = size
  end

  def to_s
      "Gutennberg Info: " + @gutenberg.to_s + "\n" +
      "License:\n"        + @licence.to_s + "\n" +
      "Ebook Nr: "        + @ebook_number.to_s + "\n" +
      "Title: "           + @title.to_s + "\n" +
      "Author: "          + @author.to_s + "\n" +
      "Illustartor: "     + @illustrator.to_s + "\n" +
      "Release Date: "    + @release_date.to_s + "\n" +
      "Language: "        + @lang.to_s + "\n" +
      "Charset: "         + @charset.to_s + "\n" +
      "Size: "            + @size.to_s + "\n"
  end 
end
  def creator(url)

info = GutenbergText.new
counter = 0
#set dummy value to text_start that it will be set by the if clause
text_start = 100

File.open("gut.text","w"){|g|
  open(url) {|f|
    f.each_line{ |line|
     counter = counter + 1 
    if info.gutenberg.nil?
     if counter == 1
     info.gutenberg = line.strip
     end
    end

      if counter<8 and counter >1
         info.licence = info.licence.to_s << line
         info.licence = info.licence.lstrip
         info.licence = info.licence.rstrip
      end
      if /START OF THE PROJECT GUTENBERG EBOOK/.match(line)
       text_start = counter
      end
    if info.title.nil?
      if /^Title:/.match(line)
        title = /^Title:/.match(line)
        title = title.post_match
        title = title.strip
        info.title = title
     end
    end
    
    if info.author.nil?
     if /^Author:/.match(line)
        author = /^Author:/.match(line)
        author = author.post_match
        author = author.strip
        info.author = author
     end
    end

    if info.illustrator.nil?
     if /^Illustrator:/.match(line)  
        illustrator = /^Illustrator:/.match(line)
        illustrator = illustrator.post_match
        illustrator = illustrator.strip
        info.illustrator = illustrator
    end
   end

   if info.ebook_number.nil? or info.release_date.nil?
     if /^Release Date:/.match(line)
        release_date = /^Release Date:/.match(line)
        release_date = release_date.post_match
        release_date = release_date.strip
        release_date = /(.*?)\s*\[(.*?)\]/.match(release_date)
        info.release_date = release_date[1]
        ebook_number = /\#(.*?)/.match(release_date[2])
        ebook_number = ebook_number.post_match
        info.ebook_number = ebook_number
     end
    end
    
    if info.lang.nil?
     if /^Language:/.match(line)
        lang = /^Language:/.match(line)
        lang = lang.post_match 
        lang = lang.strip
        info.lang = lang
     end
    end
    if info.charset.nil?
     if /^Character set encoding:/.match(line)
        charset = /^Character set encoding:/.match(line)
        charset = charset.post_match
        charset = charset.strip
        info.charset = charset
     end
   end
  if counter > text_start
   g.write(line)  
  end
    }
  }
  info.size = counter
  g.close()
}
puts info
