class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.string :license
      t.integer :enumber
      t.string :author
      t.string :lang
      t.date :release_date
      t.string :charset

      t.timestamps
    end
  end
end
