class CreateModels < ActiveRecord::Migration
  def change
    create_table :models do |t|
      t.string :name
      t.string :destination
      t.text :files, array: true, default: []

      t.timestamps null: false
    end
  end
end
