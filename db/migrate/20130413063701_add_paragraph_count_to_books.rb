class AddParagraphCountToBooks < ActiveRecord::Migration
  def change
    add_column :books, :paragraph_count, :integer, :default=>-1
  end
end
