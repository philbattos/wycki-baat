class CreateVolumes < ActiveRecord::Migration
  def change
    create_table :volumes do |t|
      t.string :name
      t.text :content
      t.string :destination
      t.string :type
      t.references :collection

      t.timestamps null: false
    end
  end
end
