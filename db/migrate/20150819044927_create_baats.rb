class CreateBaats < ActiveRecord::Migration
  def change
    create_table :baats do |t|
      t.string :name
      t.string :destination
      t.string :type
      t.string :collection
      t.text :files, array: true, default: []

      t.timestamps null: false
    end
  end
end
