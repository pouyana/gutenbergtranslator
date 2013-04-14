class AddTranslatedFromToPTranslate < ActiveRecord::Migration
  def change
  add_column :p_translates, :from_locale , :string
  add_column :p_translates, :to_locale, :string
  end
end
