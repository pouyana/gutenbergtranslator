class AddTranslatedFromToWTranslates < ActiveRecord::Migration
  def change
    add_column :w_translates, :from_locale, :string
    add_column :w_translates, :to_locale, :string
  end
end
