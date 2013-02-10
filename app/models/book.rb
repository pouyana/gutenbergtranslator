class Book < ActiveRecord::Base
  attr_accessible :author, :downloads, :lang, :number, :released_date, :size, :title

#the search function empty when search result is not set
def self.search(search)
  if search
    find(:all, :conditions => ['id LIKE ?', search])
  else
    return []
  end
end
end
