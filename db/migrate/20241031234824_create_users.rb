class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name
      t.integer :role
      t.string :key

      t.timestamps
    end
  end
end
