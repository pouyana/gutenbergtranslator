class Paragraph < ActiveRecord::Base
  attr_accessible :body, :book_id
  belongs_to :book
  has_many :p_translates
  has_many :words
  
  #translation_count should be added one number up after a diffrent status of translation existed.
  #if user translation exists, then +1
  #if reviwer translation, then +2
  #if admin translation, then +3

  def self.getTranslatedUserParagraphPercent(id)
    tsize = Paragraph.where("book_id =? And body > ? And translation_count > ? ",id,2,0).count
    psize = Paragraph.where("book_id =? And body > ?",id,2).count
    book = Book.find(id)
    percent = tsize/psize * 100
    return percent
  end

  def self.getRevTranslatedParagraphPercent(id)
    tsize = Paragraph.where("book_id =? And body > ? And translation_count > ? ",id,2,1).count
    psize = Paragraph.where("book_id =? And body > ?",id,2).count
    book = Book.find(id)
    percent = tsize/psize * 100
    return percent
  end

  def self.getTranslatedParagraphPercent(id)
    tsize = Paragraph.where("book_id =? And body > ? And translation_count > ? ",id,2,2).count
    psize = Paragraph.where("book_id =? And body > ?",id,2).count
    book = Book.find(id)
    percent = tsize/psize * 100
    return percent
  end
end
