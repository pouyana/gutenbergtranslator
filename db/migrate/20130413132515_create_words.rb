class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.string :body
      t.integer :translation_count
      t.integer :paragraph_id

      t.timestamps
    end
  end
end
