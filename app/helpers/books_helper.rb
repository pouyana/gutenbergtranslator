module BooksHelper

require 'json'
require 'httparty'

#wikidata links
#I use manily wikidata as a dictionary in this time, but mabey
#you can get more use of it. httparty our httplib here.
#the User-Agent example taken from
#https://github.com/tibbon/httparty/commit/d88eeff
#I just mocked curl to get the script work, the wikidata need to know
#your User-Agent.
#we search for the book in wikidata, in it is own language, mainly written.

def wikidataParser(locale,book)
 results=Hash.new
 title = book.title
 lang = book.lang
 baseUrl = "https://wikidata.org/w/api.php?action=wbgetentities&sites=#{lang}wiki"
 baseWiki ="https://#{locale}.wikipedia.org/wiki/"
 baseTitleUrl = baseUrl+"&titles="+title.to_s+"&format=json"
 baseTitleUrl = URI.encode(baseTitleUrl)
 wikidata = HTTParty.get(baseTitleUrl, :headers=>{"User-Agent"=>"curl/7.9.8 (i686-pc-linux-gnu) libcurl 7.9.8 (OpenSSL 0.9.6b) (ipv6 enabled)"})
 page = wikidata.body
 parsedPage = JSON.parse(page)
 results["parsedPage"] = parsedPage
 results["baseWiki"] = baseWiki
 return results
end

def wikidataResolver(parsedPage,

def wikidata(locale,book)
 parsedPage = wikidataParser(locale,book)["parsedPage"]
 baseWiki = wikidataParser(locale,book)["baseWiki"]
 wiki = "#{locale}wiki"
 if parsedPage["entities"].has_key?("-1") and parsedPage["entities"]["success"]="1"
 else
 entities = parsedPage["entities"]
 keys = result.keys
 langCounter = 0
 wikidata = Hash.new
 wikidata["hasarticle"]= false
 entities["#{keys[0]}"].each {|key|
 if  key[0]=="title"
     wikidata["title"]   = key[1]
 elsif keys[0] == "sitelinks"
      key[1].each{ |sites|
        langCounter = langCounter+1
        if sites[0] == wiki
            wikidata["hasarticle"]= true
            wikidata["wikiweb"] = URI.encode(baseWiki+sites[1]["title"])
        end
      }
    wikidata["counter"] = langCounter
 end  
   }
end
 return wikidata
end
 
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
  return paragraphs
 end
end
