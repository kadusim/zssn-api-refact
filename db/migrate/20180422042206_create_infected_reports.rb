class CreateInfectedReports < ActiveRecord::Migration[5.2]
  def change
    create_table :infected_reports do |t|
      t.references :survivor, foreign_key: true
      t.integer :reporter_id

      t.timestamps
    end
  end
end
