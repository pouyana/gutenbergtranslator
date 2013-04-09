class Book < ActiveRecord::Base

  attr_accessible :author, :downloads, :lang, :number, :released_date, :size, :title
 has_many :paragraphs
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
#takes the gutenberg link.
def gutenberg
  number=self.number
  gutenberg_base = "http://www.gutenberg.org/ebooks/"
  return gutenberg_base+number.to_s;
end
end
