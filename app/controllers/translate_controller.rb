class TranslateController < ApplicationController
  def index
      
  end
  
  def show
    @id = params[:id]
    @book = Book.find(@id)
    @percent = Paragraph.getUserTranslatedParagraphPercent(@id)
  end
  
  #ajax get paragraphs caller. 
  def getParagraphs
    @type = params[:type]
    @plimit = params[:limit]
    @id = params[:id]
    @page = params[:page]
    @offset = Paragraph.offsetCalc(@page,@plimit)
    if (@plimit.to_i > 101) || not(@plimit.to_i > 0)
      @plimit = 10
    end
    case @type
      when "0"
      Paragraph.setUntranslatedParagraphs(@id,@plimit,@offset)
      @paragraphs = Paragraph.getUntranslatedParagraphs
      when "1"
      Paragraph.setTranslatedParagraphs(@id,@plimit,@offset)
      @paragraphs = Paragraph.getTranslatedParagraphs
      when "2"
      Paragraph.setAllParagraphs(@id,@plimit,@offset)
      @paragraphs = Paragraph.getAllParagraphs
    end
    respond_to do |format|
      format.json
    end
  end

end
