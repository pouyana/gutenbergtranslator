class AddTranslationsCountToParagraph < ActiveRecord::Migration
  def change
  add_column :paragraphs, :translation_count, :integer
  end
end
