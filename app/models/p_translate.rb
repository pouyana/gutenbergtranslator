class PTranslate < ActiveRecord::Base
  attr_accessible :accepted, :body, :paragraph_id, :status, :user_id
  belongs_to :paragraph
end
