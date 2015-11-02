class AddCollectionToTemplates < ActiveRecord::Migration
  def change
    add_column :templates,      :collection_name, :string
    add_column :volumes,        :collection_name, :string
    add_column :pdf_originals,  :collection_name, :string
    add_column :pdf_originals,  :collection_id,   :integer
    add_column :pdf_originals,  :categories,      :text,    array: true, default: []
    add_column :images,         :categories,      :text,    array: true, default: []
    add_column :images,         :collection_name, :string
    add_column :images,         :collection_id,   :integer
  end
end
