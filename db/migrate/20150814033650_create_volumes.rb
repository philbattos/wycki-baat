class CreateVolumes < ActiveRecord::Migration
  def change
    create_table :volumes do |t|
      t.string :name
      t.string :destination

      t.timestamps null: false
    end
  end
end
