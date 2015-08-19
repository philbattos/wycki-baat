class AddFilesToTemplates < ActiveRecord::Migration
  def change
    add_column :templates, :files, :text, array: true, default: []
  end
end
