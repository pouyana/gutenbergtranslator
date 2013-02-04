class Book < ActiveRecord::Base
  attr_accessible :author, :downloads, :lang, :number, :released_date, :size, :title


def self.search(search)
  if search
    find(:all, :conditions => ['id LIKE ?', search])
  else
    find(:all)
  end
end
end
