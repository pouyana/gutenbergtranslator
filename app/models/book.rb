class Book < ActiveRecord::Base

  attr_accessible :author, :downloads, :lang, :number, :released_date, :size, :title, :paragraph_count, :path_id
  has_many :paragraphs
  has_one :paths
  
  #filter will be implimented to allow multiple options in search
  def self.filter(search)
  
  end

  #the search only works with on parameter
  def self.search(search)
    if search
      if search[:number]
        find(:all, :conditions => ['number LIKE ?', "%#{search[:search]}%"])
      elsif search[:title]
        find(:all,:order=>"number ASC", :conditions => ['title LIKE ?', "%#{search[:search]}%"])
      elsif search[:author]
        find(:all, :conditions => ['author LIKE ?', "%#{search[:search]}%"])
      else
        return []
      end
    else 
      return []
    end
  end

  #creates gutenburg link constanst
  def gutenberg
    number=self.number
    gutenberg_base = "http://www.gutenberg.org/ebooks/"
    return gutenberg_base+number.to_s;
  end

  #CombinesUrl with parameters
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

  #add textParagraphs to Database
  def self.textToParagraph(textFile,bookid)
    paragString=""
    c=0
    paragraphs=[];
    textFile.each_line do |line|
        if(/\n/.match(line.to_s) and line.length>2)
          paragString=paragString+line.to_s
        else
          paragraphs << Paragraph.new(:book_id=>bookid,:body=>paragString)
          c=c+1
          paragString=""
        end
      end
    paragraphs.each_slice(500) do |para|
      Paragraph.import para
    end
    return c
  end
  
  #saves the book file
  def self.booksave(bookid,text,url)
    textFile = text
    ################################################################################################
    # random name generator for more privacy and also bandwidth saving.                             #
    # the files could be acciable to internet as they are free (Free as in GNU)                     #
    # the code is taken from stackoverflow page, it is in CC-BY-SA 2.                               #
    # source: http://stackoverflow.com/questions/88311/how-best-to-generate-a-random-string-in-ruby #
    ################################################################################################
    o =  [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten
    filename = (0...20).map{ o[rand(o.length)] }.join 
    if (not(Path.where(:book_id=>bookid).exists?))
      dir="public/txt"
      File.open(File.join(dir,filename),"wb") do |tosave|
        tosave.write(textFile)
      end
      path = Path.new(:book_id=>bookid,:txt=>filename,:url=>url)
      path.save
      Book.update(bookid,:path_id=>path.id)
    end
  end

  #Resolves the book from the server using UrlCombinator
  def self.bookresolver(bookid)
    result = false
    text = false
    book=Book.find(bookid)
    combination=["",0,8]
    combination.each do |comb|
      if(not(result))
        combinedUrl = self.urlCombinator(comb,book.number)
        begin
          textFile=HTTParty.get(combinedUrl)
          case textFile.code
          when 200
            result = true
            text = textFile
            self.booksave(bookid,text,combinedUrl)
          when 404
            result = false
          end
        rescue =>e
          puts "Gutenberg not acceable please check your Internet connection"
          text=false
        end
      end
    end
    return text
  end

  #check if the books exists local or not
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

  #the whole addParagraph happens here.
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
  end 
    
end
