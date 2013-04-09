require 'httparty'
 
 def urlCombinator(options,id)
    baseUrl="http://www.gutenberg.org/files/"+id.to_s+"/"
    combinedUrl =""
    case options
     when ""
      combinedUrl = baseUrl+id.to_s+".txt"
     when 0
      combinedUrl = baseUrl+id.to_s+"-0.txt"
     when 8
      combinedUrl = baseUrl+id.to_s+"-8.txt"
    end
    combinedUrl=URI.encode(combinedUrl)
    return combinedUrl
 end

 def textToParagrap(textFile)
  paragString=""
  paragraphs = Array.new
  textFile.each_line do |line|
   if(/\n/.match(line.to_s) and line.length>2)
    paragString=paragString+line.to_s
   else
    paragraphs.push(paragString)
    paragString=""
   end
  end
  return paragraphs
 end

 def addParagraph(bookid)
    combinedUrl = urlCombinator("",bookid)
    textFile=HTTParty.get(combinedUrl)
    if (textFile.code==200)
       paragraphs=textToParagrap(textFile) 
    elsif (textFile.code==404)
      combinedUrl = urlCombinator(0,bookid)
      textFile=HTTParty.get(combinedUrl)
      if (textFile.code==200)
       paragraphs=textToParagrap(textFile)
      else
       combinedUrl = urlCombinator(8,bookid)
       textFile=HTTParty.get(combinedUrl)
       paragraphs=textToParagrap(textFile)
       end
    end 
  return paragrpahs
 end
