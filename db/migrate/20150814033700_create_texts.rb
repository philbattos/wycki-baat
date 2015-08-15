class CreateTexts < ActiveRecord::Migration
  def change
    create_table :texts do |t|
      t.string :name
      t.string :destination

      t.timestamps null: false
    end
  end
end
