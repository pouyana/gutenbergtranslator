class CreatePTranslates < ActiveRecord::Migration
  def change
    create_table :p_translates do |t|
      t.string :body
      t.integer :user_id
      t.integer :status
      t.integer :paragraph_id
      t.boolean :accepted

      t.timestamps
    end
  end
end
