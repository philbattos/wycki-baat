class CreateModels < ActiveRecord::Migration
  def change
    create_table :templates do |t|
      t.string :name
      t.text :content
      t.string :destination
      t.string :type
      t.text :file_path
      t.text :file_name
      t.text :file_headers
      t.string :file_root
      t.string :file_extension
      t.text :categories, array: true, default: []
      t.decimal :file_size
      t.text :api_response
      t.string :aasm_state

      t.timestamps null: false
    end
  end
end
