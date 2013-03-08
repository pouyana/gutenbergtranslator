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
def wikidata(locale,book)

 title = book.title
 lang = book.lang
 baseUrl = "https://wikidata.org/w/api.php?action=wbgetentities&sites=#{lang}wiki"
 wiki = "#{locale}wiki"
 baseWiki ="https://#{locale}.wikipedia.org/wiki/"
 baseTitleUrl = baseUrl+"&titles="+title.to_s+"&format=json"
 baseTitleUrl = URI.encode(baseTitleUrl)
 wikidata = HTTParty.get(baseTitleUrl, :headers=>{"User-Agent"=>"curl/7.9.8 (i686-pc-linux-gnu) libcurl 7.9.8 (OpenSSL 0.9.6b) (ipv6 enabled)"})
 page = wikidata.body
 parsedPage = JSON.parse(page)
 if parsedPage["entities"].has_key?("-1") and parsedPage["entities"]["success"]="1"
 #do nothing
 else
 result = parsedPage["entities"]
 id = result.keys
 langCounter = 0
 wikidata = Hash.new
 wikidata["hasarticle"]= false
 result["#{id[0]}"].each {|keys|
 if  keys[0]=="title"
     wikidata["title"]   = keys[1]
 elsif keys[0] == "sitelinks"
      keys[1].each{ |sites|
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
end
