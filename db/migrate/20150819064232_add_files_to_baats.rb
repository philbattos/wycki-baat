class AddFilesToBaats < ActiveRecord::Migration
  def change
    add_column :baats, :files, :text, array: true, default: []
  end
end
