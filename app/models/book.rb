# == Schema Information
#
# Table name: books
#
#  id           :integer          not null, primary key
#  title        :string(255)
#  license      :string(255)
#  enumber      :integer
#  author       :string(255)
#  lang         :string(255)
#  release_date :date
#  charset      :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Book < ActiveRecord::Base
  attr_accessible :author, :charset, :enumber, :lang, :license, :release_date, :title
end
