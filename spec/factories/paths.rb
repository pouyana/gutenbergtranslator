# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :path do
    pdf "MyString"
    book_id 1
    url "MyString"
    txt "MyString"
  end
end
