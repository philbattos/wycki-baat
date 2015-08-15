class CreateFolios < ActiveRecord::Migration
  def change
    create_table :folios do |t|
      t.string :name
      t.string :destination

      t.timestamps null: false
    end
  end
end
