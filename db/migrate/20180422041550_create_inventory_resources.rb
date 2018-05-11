class CreateInventoryResources < ActiveRecord::Migration[5.2]
  def change
    create_table :inventory_resources do |t|
      t.references :inventory, foreign_key: true
      t.references :resource, foreign_key: true

      t.timestamps
    end
  end
end
