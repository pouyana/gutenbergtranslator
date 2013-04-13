class Paragraph < ActiveRecord::Base
  attr_accessible :body, :book_id
  belongs_to :book
end
