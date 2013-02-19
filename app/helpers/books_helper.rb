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


#get amazon details
require 'amazon/ecs'
def amazon(book)
Amazon::Ecs.options = {
  :associate_tag => 'gitipaycom-21',
  :AWS_access_key_id => "AKIAICIBDOFLRCULNF6A",       
  :AWS_secret_key => "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"}
res = Amazon::Ecs.item_search('ruby', {:response_group => 'Medium', :sort => 'salesrank'})
return res.total_results
end
end
