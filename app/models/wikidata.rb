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


#to use the class you have to run dataminer method. without it you get empty object
class Wikidata

  #constructer method
  def initialize(book,locale)
    @book,@locale = book,locale
  end

  #parse Json Page
  def getParser
    title = @book.title
    lang = @book.lang
    baseUrl = "https://wikidata.org/w/api.php?action=wbgetentities&sites=#{lang}wiki"
    baseTitleUrl = baseUrl+"&titles="+title.to_s+"&format=json"
    baseTitleUrl = URI.encode(baseTitleUrl)
    begin
      wikidata = HTTParty.get(baseTitleUrl, :headers=>{"User-Agent"=>"curl/7.9.8 (i686-pc-linux-gnu) libcurl 7.9.8 (OpenSSL 0.9.6b) (ipv6 enabled)"})
      page = wikidata.body
      parsedPage = JSON.parse(page)
    rescue => e
      puts "Error with httparty, mainly no connection to wikidata."
      parsedpage = false
    end
    @parsedPage = parsedPage
    return @parsedPage
  end

  #creates bases, it is needed to find out if we have an article in given langage wikipedia.
  def getBase
    base = Hash.new
    base["Name"] = "#{@locale}wiki"
    base["Url"] = "https://#{@locale}.wikipedia.org/wiki/"
    @base = base
    return @base
  end
  
  #Mines the ParsedPage, got by getParser method
  def dataMiner
    wikidata = Hash.new
    setHasArticle(false)
    if(parsedPage=getParser)
      if parsedPage["entities"].has_key?("-1") and parsedPage["entities"]["success"]="1"
      else
        entities = parsedPage["entities"]
        id = entities.keys
        entities["#{id[0]}"].each do |keys|
          if keys[0]=="title"
          elsif keys[0] == "sitelinks"
            setArticleTitles(keys[1])
            articleCounter
          end
        end
      end
    end
  end
  
  #getter, checks if article exists.
  def getHasArticle
    @hasArticle
  end
  
  #alias
  alias :hasArticle :getHasArticle
  
  #setter, sets article existing or not
  def setHasArticle(value)
    @hasArticle = value
  end
  
  #gives wikipedia url in local language
  def getWikipediaUrl
    @wikipediaUrl  
  end
  
  #set wikipedia url in local language
  def setWikipediaUrl(value)
    @wikipediaUrl=value
  end
  
  #counts articles existing in wikipedia about the subject in diffrent languages
  def getArticleCount
    @count
  end
  #alias
  alias :articleCount :getArticleCount
  
  def articleCounter
    setArticleCount = 0
    counter = 0
    base = getBase
    titles = getArticleTitles
    titles.each do |titles|
      counter = counter+1
      if titles[0] == base["Name"]
        setHasArticle(true)
        setWikipediaUrl(URI.encode(base["Url"]+titles[1]["title"]))
      end
    end
    setArticleCount(counter)
  end


  #set article counts
  def setArticleCount(value)
    @count = value
  end

  #get Article titles in other languages
  def getArticleTitles
    @titles
  end
  
  #set Article titles array
  def setArticleTitles(value)
    @titles = value
  end

  #make the articles private
  private :getArticleTitles,:setArticleTitles
end
