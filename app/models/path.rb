class Path < ActiveRecord::Base
  attr_accessible :book_id, :pdf, :txt, :url
  validates :book_id, :uniqueness=>true
  validates :txt, :presence => true
end
