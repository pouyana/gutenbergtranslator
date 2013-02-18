module BooksHelper

require 'wikipedia'
require 'json'

#get the wikipedia links
def wikipedia(locale,book)
 result = []
 base = "#{locale}.wikipedia.org"
 Wikipedia.Configure {
  domain base
  path   'w/api.php'
 }
 page =  Wikipedia.find(book.title, :prop=>"info")
 parsed_page = JSON.parse(page.json)
# #check if it exists.
 if parsed_page["query"]["pages"].has_key?("-1")
 else
 wiki_base = "http://#{locale}.wikipedia.org/wiki/"
 result = wiki_base+book.title
 end
 return result
end

end
