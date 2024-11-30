class AddUniqueIndexToMeasurements < ActiveRecord::Migration[7.1]
  def change
    add_index :measurements, "LOWER(unit)", unique: true, name: "index_measurements_on_lower_unit", using: :btree

  end
end
