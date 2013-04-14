class Word < ActiveRecord::Base
  attr_accessible :body, :paragraph_id, :translation_count
  belongs_to :parahraph
  has_many :w_translates
end
