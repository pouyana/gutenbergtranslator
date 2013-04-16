class TranslateController < ApplicationController
  def index
      
  end
  
  def show
    # to be noticed that paragraphs of empty lines are not add, as they are nessary for the format
    # but there is no need to translate them.
    # I want to pass limit also as a parameter, with default value of 10
    @paragraphs = Paragraph.where("book_id =? And body > ?",params[:id],2).limit(10)
    @book = Book.find(params[:id])
    #percent needs more work
    @percent = Paragraph.getUserTranslatedParagraphPercent(params[:id])
  end
  
  #ajax get paragraphs caller. 
  def getParagraphs
    if params[:limit] and params[:limit].to_i < 101
      plimit = params[:limit]
    else
      plimit = 10
    end
#    @paragraphs = Paragraph.where("book_id =? And body > ?",params[:id],2).limit(plimit)
    if(Paragraph.getAllParagraphs!=nil)
      @paragraphs = Paragraph.getAllParagraphs
    else
      Paragraph.setAllParagraphs(params[:id],plimit,10)
      @paragraphs = Paragraph.getAllParagraphs
    end
    respond_to do |format|
      format.json
    end
  end

  def getTranslatedParagraphs(status)

  end

  def getNotTranslatedParagraphs

  end
  
end

