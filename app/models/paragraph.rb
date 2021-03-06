class Paragraph < ActiveRecord::Base
  attr_accessible :body, :book_id
  belongs_to :book
  has_many :p_translates
  has_many :words
  
  #translation_count should be added one number up after a diffrent status of translation existed.
  #if user translation exists, then +1
  #if reviewer translation, then +2
  #if admin translation, then +3

  #helper methods.(just working, exceptions not handeld).
  def self.offsetCalc(page,limit)
    @page = page.to_i
    @limit = limit.to_i
    @offset = 0
    if @page > 0
      @offset = @page * @limit
    end
    return @offset
  end
  #Paragraph Count and Percent Methods  >>>
  def self.getTranslatedParagraphsCount
    @translatedParagraphCount
  end

  def self.setTranslatedParagraphsCount(id,status)
    @translatedParagraphCount = self.where("book_id =? And body > ? And translation_count > ? ",id,2,status).count
  end

  def self.getAllParagraphsCount
    @allParagraphsCount
  end

  def self.setAllParagraphsCount(id)
    @allParagraphsCount = self.where("book_id =? And body > ?",id,2).count
  end

  def self.getTranslatedParagraphPercent(id,status)
      self.setTranslatedParagraphsCount(id,status)
      self.setAllParagraphsCount(id)
      tsize = self.getTranslatedParagraphsCount()
      psize = self.getAllParagraphsCount()
      return tsize/psize * 100 
  end

  def self.getUserTranslatedParagraphPercent(id)
    return self.getTranslatedParagraphPercent(id,0)
  end

  def self.getRevTranslatedParagraphPercent(id)
    return self.getTranslatedParagraphPercent(id,1)
  end

  def self.getAdminTranslatedParagraphPercent(id)
    return self.getTranslatedParagraphPercent(id,2)
  end
  
  #ParagraphMethods >>>
  def self.getAllParagraphs
    @allParagraphs
  end
  
  #offset to skip how many objects needed. everypage should have offset added by  limit.
  def self.setAllParagraphs(id,size,offset)
    @allParagraphs = self.where("book_id =? And body > ?",id,2).limit(size).offset(offset)
  end

  def self.getTranslatedParagraphs
    @translatedParagraphs
  end

  #here the first status user translated is alos enough, set manualy
  def self.setTranslatedParagraphs(id,size,offset)
    @translatedParagraphs = self.where("book_id =? And body > ? And translation_count > ? ",id,2,0).limit(size).offset(offset)
  end

  def self.getUntranslatedParagraphs
    @untranslatedParagraphs
  end

  def self.setUntranslatedParagraphs(id,size,offset)
    @untranslatedParagraphs = self.where("book_id =? And body > ? And translation_count IS ? ",id,2,nil).limit(size).offset(offset)
  end

end
