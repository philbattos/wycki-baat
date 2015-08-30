class CreatePortals < ActiveRecord::Migration
  def change
    create_table :portals do |t|
      t.string :request_source
      t.string :request_destination
      t.text :query
      t.text :response

      t.timestamps null: false
    end
  end
end
