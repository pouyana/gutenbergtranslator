class Book < ActiveRecord::Base
  attr_accessible :author, :downloads, :lang, :number, :released_date, :size, :title
#the search function empty when search result is not set

def self.filter(search)
if search
  






end
end

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
