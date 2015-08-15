class CreateWikiBots < ActiveRecord::Migration
  def change
    create_table :wiki_bots do |t|
      t.string  :name
      t.string  :site_url
      t.string  :api_endpoint

      t.timestamps null: false
    end
  end
end
