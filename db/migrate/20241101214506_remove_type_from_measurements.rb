class RemoveTypeFromMeasurements < ActiveRecord::Migration[7.1]
  def change
    remove_column :measurements, :type, :string
  end
end
