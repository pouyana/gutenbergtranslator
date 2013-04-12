class FixPathid < ActiveRecord::Migration
  def up
    rename_column :books, :file_id, :path_id
  end

  def down
  end
end
