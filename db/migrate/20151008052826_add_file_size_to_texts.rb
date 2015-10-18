class AddFileSizeToTexts < ActiveRecord::Migration
  def change
    add_column :texts, :file_size, :decimal
    add_column :texts, :api_response, :text
    add_column :texts, :aasm_state, :string

    add_column :volumes, :aasm_state, :string
    add_column :volumes, :api_response, :text

    add_column :pdf_originals, :aasm_state, :string
    add_column :pdf_originals, :api_response, :text

    add_column :images, :aasm_state, :string
    add_column :images, :api_response, :text
  end
end
