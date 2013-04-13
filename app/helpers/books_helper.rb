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

def wikicounter(keys,wikidata,baseWiki,wiki)
counter = 0
keys.each do |wikis|
  counter = counter+1
  if wikis[0] == wiki
    wikidata["hasarticle"]=true
    wikidata["wikiweb"] = URI.encode(baseWiki+wikis[1]["title"])
  end
 end
 wikidata["counter"]=counter
end

def wikidataMiner(parsedPage,wiki,baseWiki)
 wikidata = Hash.new
 if parsedPage["entities"].has_key?("-1") and parsedPage["entities"]["success"]="1"
 else
  entities = parsedPage["entities"]
  id = entities.keys
  wikidata["hasarticle"]= false
  entities["#{id[0]}"].each do |keys|
  if keys[0]=="title"
    wikidata["title"] = keys[1]
  elsif keys[0] == "sitelinks"
  wikicounter(keys[1],wikidata,baseWiki,wiki)
  end
  end
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

def self.urlCombinator(options,id)
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

def self.textToParagraph(textFile,bookid)
  paragString=""
  c=0
  textFile.each_line do |line|
   if(/\n/.match(line.to_s) and line.length>2)
    paragString=paragString+line.to_s
   else
    tmp_paragraph= Paragraph.new(:book_id=>bookid,:body=>paragString)
    tmp_paragraph.save
    c=c+1
    paragString=""
   end
  end
return c
end

def self.booksave(bookid,text,url)
 textFile = text
#random name generator for more privacy and also bandwidth saving.
#the files could be acciable to internet as they are free (Free as in GNU)
#the code is taken from stackoverflow page, it is in CC-BY-SA 2.
#source: http://stackoverflow.com/questions/88311/how-best-to-generate-a-random-string-in-ruby
 o =  [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten
 filename = (0...20).map{ o[rand(o.length)] }.join 
 if (not(Path.where(:book_id=>bookid).exists?))
  dir="public/txt"
  File.open(File.join(dir,filename),"wb") do |tosave|
   tosave.write(textFile)
  end
  path = Path.new(:book_id=>bookid,:txt=>filename,:url=>url)
  path.save
 end
end


def self.bookresolver(bookid)
 result = false
 text = false
 combination=["",0,8]
 combination.each do |comb|
  if(not(result))
   combinedUrl = self.urlCombinator(comb,bookid)
   textFile=HTTParty.get(combinedUrl)
   case textFile.code
    when 200
    result = true
    text = textFile
    self.booksave(bookid,text,combinedUrl)
    when 404
    result = false
   end
  end
 end
 return text
end

#the where method, gives an array object, so you have to pop the first result out
def self.booklocal(bookid)
  path = Path.where(:book_id=>bookid)
  if (path.exists?)
    dir = "public/txt"
    file = File.open(File.join(dir,path.pop.txt),"r")
    text = file.read
    file.close
  else
  text = self.bookresolver(bookid)
  end
 return text
end

def self.addParagraph(bookid)
    paragraphs=0
    text = self.booklocal(bookid)
    book = Book.find(bookid)
    if(book.paragraph_count==-1)
      if (text) 
       counter = self.textToParagraph(text,bookid)
       Book.update(bookid, :paragraph_count => counter)
      end
    end
 return book.paragraph_count
end
end
