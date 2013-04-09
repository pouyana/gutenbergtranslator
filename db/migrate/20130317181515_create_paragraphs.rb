class CreateParagraphs < ActiveRecord::Migration
  def change
    create_table :paragraphs do |t|
      t.text :body
      t.references :book
      t.timestamps
    end
      add_index :paragraphs, :book_id
  end
end
