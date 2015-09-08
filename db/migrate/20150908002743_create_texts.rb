class CreateTexts < ActiveRecord::Migration
  def change
    create_table :texts do |t|
      t.text :name
      t.text :content
      t.string :destination
      t.string :type
      t.text :file_path
      t.text :file_name
      t.text :file_headers
      t.string :file_root
      t.string :file_extension
      t.text :categories, array: true, default: []
      t.references :volume

      t.timestamps null: false
    end
  end
end
