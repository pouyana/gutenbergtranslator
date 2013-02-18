class BooksController < ApplicationController
  def index
   redirect_to :action => "search"
  end
#as there is no new books, when sb just wtite this in url gets back to index.
  def new
   redirect_to :action => "index"
  end
  def show
   @book = Book.find(params[:id])
  end
  def search
   @books = Book.search(params)
  end
end
