class Word < ActiveRecord::Base
  attr_accessible :body, :paragraph_id, :translation_count
end
