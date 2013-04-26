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
    @page = params[:page].to_i-1
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

  #Machine Translation uses word translation and Grammatic Module. Both of them and engine itself should be wrtitten.
  #the machine translation is only a mere suggestion, and has most of them error. the human translated text is always
  #will be compared to machine one and the machine will try to get the human logic and add it it's rules.
  #as this is a exprimental project, the machine generated rules will be checked before add the engine database.
  #paramter passed to this function will be just the string text and input/output lang. machine have to know the source and output
  #of translation.
  #both getEngineTranslation and getDictionaryTranslation will use a lookup function.
  def getEngineTranslation

  end
  
  #checks if there is a direct translation of the text somewhere. first it will look up inside the book and after that author's
  #book after, nothing found he will searched throgh the whole database.paramter passed to this function (method) will be book,
  #book->author,and the author->books->paragarphs, and at last whole translated paragraphs.
  #the search function is yet to be decided. :D
  def getHumanTranslation

  end

  #Suggesten Translations will suggest some hints for the translator to give the translator a chance to make the translation fluent.
  #as this project will get lots of people editing the whole text, it is not that easy to make homogen text and without repeatation.
  #Suggestion function will analyse the translated text before and will give some hints for every paragraph get translated. ex. Name of 
  #Places get same Translation, Name of People the same, Common Names also.
  def getSuggestionTranslation

  end

  #it is merely a dictrionay, as user just high-light a word in the text box it will strat to search Bing/Wikitoinary/WikiData/(Google) and
  #also the word dictionary created by the user it self.
  #if the word had more translation it will be added as dropdown boxes.
  #
  def getDictinaryTranslation

  end

  #it will create a phonetic syntax from word and then manage to map the chars to the same phonetics in the other language. very useful for
  #the Common names that dont have any translations in Wikipedia/Wikidata or Bing (the translation can be added to wikidata any how :).
  def getPhoneticfromWord

  end
end
