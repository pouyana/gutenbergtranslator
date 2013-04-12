class CreatePaths < ActiveRecord::Migration
  def change
    create_table :paths do |t|
      t.string :pdf
      t.integer :book_id
      t.string :url
      t.string :txt

      t.timestamps
    end
  end
end
