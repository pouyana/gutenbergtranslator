class Paragraph < ActiveRecord::Base
  attr_accessible :body, :bookid
  belongs_to :book
end
