class CreatePdfOriginals < ActiveRecord::Migration
  def change
    create_table :pdf_originals do |t|
      t.string :name
      t.string :destination

      t.timestamps null: false
    end
  end
end
