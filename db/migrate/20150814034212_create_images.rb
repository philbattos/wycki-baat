class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :name
      t.string :destination

      t.timestamps null: false
    end
  end
end
