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
 title = book.title
 lang = book.lang
 baseUrl = "https://wikidata.org/w/api.php?action=wbgetentities&sites=#{lang}wiki"
 baseTitleUrl = baseUrl+"&titles="+title.to_s+"&format=json"
 baseTitleUrl = URI.encode(baseTitleUrl)
 wikidata = HTTParty.get(baseTitleUrl, :headers=>{"User-Agent"=>"curl/7.9.8 (i686-pc-linux-gnu) libcurl 7.9.8 (OpenSSL 0.9.6b) (ipv6 enabled)"})
 page = wikidata.body
 parsedPage = JSON.parse(page)
 return parsedPage
end

def wikidataGetBaseWiki(locale)
 wiki=Hash.new
 wiki["Base"]= "#{locale}wiki"
 wiki["Url"] ="https://#{locale}.wikipedia.org/wiki/"
 return wiki
end

def wikidataMiner(parsedPage,wiki,baseWiki)
 
 wikidata = Hash.new
 if parsedPage["entities"].has_key?("-1") and parsedPage["entities"]["success"]="1"
 else
  entities = parsedPage["entities"]
  id = entities.keys
  counter = 0
  wikidata["hasarticle"]= false
  entities["#{id[0]}"].each do |keys|
  if keys[0]=="title"
    wikidata["title"] = keys[1]
  elsif keys[0] == "sitelinks"
   keys[1].each do |sites|
   counter = counter+1
   if sites[0] == wiki
    wikidata["hasarticle"]= true
    wikidata["wikiweb"] = URI.encode(baseWiki+sites[1]["title"])
   end
  end
 end
  end
    wikidata["counter"] = counter
end
 return wikidata
end

def wikidata(locale,book)
 newWiki=wikidataGetBaseWiki(locale)
 parsedPage = wikidataParser(locale,book)
 wiki = newWiki["Base"]
 baseWiki =newWiki["Url"]
 wikidata=wikidataMiner(parsedPage,wiki,baseWiki)
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
