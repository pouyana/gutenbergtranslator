# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :book do
    number 1
    title ""
    author "MyString"
    released_date "2013-01-24"
    lang "MyString"
    downloads 1
    size 1
  end
end
