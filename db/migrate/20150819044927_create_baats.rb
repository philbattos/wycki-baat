class CreateBaats < ActiveRecord::Migration
  def change
    create_table :baats do |t|
      t.string :name
      t.string :destination
      t.string :type

      t.timestamps null: false
    end
  end
end
