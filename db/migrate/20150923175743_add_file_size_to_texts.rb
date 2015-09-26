class AddFileSizeToTexts < ActiveRecord::Migration
  def change
    add_column :texts, :file_size, :decimal
    add_column :texts, :api_response, :text
    add_column :texts, :aasm_state, :string

    add_column :volumes, :aasm_state, :string
  end
end