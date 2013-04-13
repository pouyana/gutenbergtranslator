# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :word do
    body "MyString"
    translation_count 1
    paragraph_id 1
  end
end
