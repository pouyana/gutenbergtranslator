class Book < ActiveRecord::Base
  attr_accessible :author, :downloads, :lang, :number, :released_date, :size, :title
#filter will be implimented to allow multiple options in search
def self.filter(search)
  
end
#the search only works with on parameter
def self.search(search)
  if search
   if search[:number]
    find(:all, :conditions => ['number LIKE ?', "%#{search[:search]}%"])
   elsif search[:title]
    find(:all, :conditions => ['title LIKE ?', "%#{search[:search]}%"])
   elsif search[:author]
    find(:all, :conditions => ['author LIKE ?', "%#{search[:search]}%"])
   else
   return []
  end
  else 
   return []
 end
end
end
