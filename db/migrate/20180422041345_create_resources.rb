class CreateResources < ActiveRecord::Migration[5.2]
  def change
    create_table :resources do |t|
      t.string :item
      t.integer :value

      t.timestamps
    end
  end
end
