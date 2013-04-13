class WTranslate < ActiveRecord::Base
  attr_accessible :accepted, :body, :status, :tag, :user_id, :word_id
end
