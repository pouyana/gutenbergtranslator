class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.integer :number
      t.string :title
      t.string :author
      t.date :released_date
      t.string :lang
      t.integer :downloads
      t.integer :size
      t.timestamps
    end
  end
end
