class Paragraph < ActiveRecord::Base
  attr_accessible :body, :book_id
  belongs_to :book
  has_many :p_translates
  has_many :words
end
