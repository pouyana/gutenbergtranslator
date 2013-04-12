class AddFileidToBook < ActiveRecord::Migration
  def change
    add_column :books, :fileid, :integer, :default=>0
  end
end
