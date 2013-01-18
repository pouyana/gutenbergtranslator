# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :book do
    title "MyString"
    license ""
    enumber ""
    author "MyString"
    lang "MyString"
    release_date "2013-01-19"
    charset "MyString"
  end
end
