class AddImageFileToImages < ActiveRecord::Migration
  def change
    add_column :images, :image_file, :string
    add_column :pdf_originals, :pdf_file, :string
  end
end
