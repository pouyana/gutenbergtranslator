#!/usr/local/bin/ruby
require 'rdf/raptor'   # Support for RDF/XML (.rdf) and Turtle (.ttl)
require 'date'
require 'sqlite3'

database = SQLite3::Database.open "../db/development.sqlite3"

#class book
class GutenbergText
  attr_accessor :ebook_number , :title, :author, :release_date, :lang,:size,:downloads

  def initilize(ebook_number,title,author,release_date,lang,size ,downloads)
      @ebook_number = ebook_number
      @title = title
      @author = author
      @release_date = release_date
      @lang = lang
      @size = size
      @downloads = downloads
  end

  def to_s
      "Ebook Nr: "        + @ebook_number.to_s + "\n" +
      "Title: "           + @title.to_s + "\n" +
      "Author: "          + @author.to_s + "\n" +
      "Release Date: "    + @release_date.to_s + "\n" +
      "Language: "        + @lang.to_s + "\n" +
      "Size: "            + @size.to_s + "\n" +
      "Downloads: "       + @downloads.to_s + "\n\n"
  end 
end

#RDFObject to record everything in it.
class RdfObj 
attr_accessor :subject, :predicate, :object

def initilize(subject,predicate,object)
 @subject = subject
 @predicate = predicate
 @object = object
end
end

def existsCheck( db, id )
    db.execute( "select 1
                 from books
                 where number = ?",
                [id] ).length > 0
end

def addToDatabase (db,book)
   stmt = db.prepare("Insert INTO books (number,title,author,lang,downloads,created_at,updated_at) VALUES (:number,:title,:author,:lang,:downloads,date('now'),date('now'))")
   stmt.bind_params("number"=>book.ebook_number.to_s.to_i,"title"=>book.title,"author"=>book.author,"lang"=>book.lang,"downloads"=>book.downloads)
   stmt.execute
end

counter = 0
charset_set = false
time_set = false
downloads_set = false
books = Array.new
rdfdict = Array.new
dc = "http://purl.org/dc/elements/1.1/"
terms = "http://purl.org/dc/terms/"
#the main book reader
RDF::Reader.open("catalog.rdf") do |reader|
  reader.each_triple do |subject, predicate, object|
#put the rdf datas in the object array so they can be used later when have a bag of objects
    rdfobj = RdfObj.new
    rdfobj.subject=subject 
    rdfobj.predicate = predicate
    rdfobj.object = object
    rdfdict.push(rdfobj)
    bookid = /etext\d[^a-z]*/.match(subject.to_s)
    if (bookid == bookid and bookid!=nil)
     ebook_number=/\d[^a-z]*/.match(bookid.to_s)
     lastbook = books.last
     if books.empty? or not(lastbook.ebook_number==ebook_number)
      lastest = books.pop
      id = ebook_number.to_s.to_i
      if not(existsCheck(database,id)) and lastest!=nil
               addToDatabase(database,lastest)
               p "adding the book" + lastest.to_s + "to Database"
      end
      info = GutenbergText.new
      rdfdict.clear
      ebook_number=/\d[^a-z]*/.match(bookid.to_s)
      info.ebook_number = ebook_number
      books.push(info)
     end 
     
     if predicate == dc+"title"
        info = books.pop
        info.title = object.to_s
        books.push(info)
     end    
     if predicate == dc+"creator"
        info = books.pop
        author = ""
        if  /..g[0-9].*/.match(object.to_s)
          rdfdict.each { |rdfobj| 
            if rdfobj.subject == object and not(/^http.*/.match(rdfobj.object.to_s))
             author = rdfobj.object.to_s + " and " + author
            end
        }
#to remove the last and from chars
        info.author = author[0..-5]
        else
        info.author = object.to_s
        end
        books.push(info)
    end
   end   
#Mischelius Chars :)
    if charset_set
     info = books.pop
     info.lang = object.to_s
     charset_set = false
     books.push(info)
    end
    
    if object == terms+"ISO639-2"
      charset_set = true
    end
    
    if time_set and not(books.empty?)
     info = books.pop
     info.release_date = object.to_s
     time_set = false
     books.push(info)
    end
    
    if object == terms+"W3CDTF"
     time_set = true
    end
    
    if downloads_set
     info = books.pop
     info.downloads = object.to_s.to_i
     downloads_set = false
     books.push(info)
    end
   
    if object == "http://www.w3.org/2001/XMLSchema#nonNegativeInteger"
     downloads_set = true
    end
  end
end
