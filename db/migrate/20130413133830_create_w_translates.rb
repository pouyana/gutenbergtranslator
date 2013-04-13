class CreateWTranslates < ActiveRecord::Migration
  def change
    create_table :w_translates do |t|
      t.string :body
      t.integer :user_id
      t.integer :status
      t.integer :word_id
      t.boolean :accepted
      t.string :tag

      t.timestamps
    end
  end
end
