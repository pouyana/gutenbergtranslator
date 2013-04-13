# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :w_translate do
    body "MyString"
    user_id 1
    status 1
    word_id 1
    accepted false
    tag "MyString"
  end
end
