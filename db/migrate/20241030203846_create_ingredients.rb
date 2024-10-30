class CreateIngredients < ActiveRecord::Migration[7.1]
  def change
    create_table :ingredients do |t|
      t.string :name
      t.float :national_price
      t.boolean :taxable
      t.boolean :snap

      t.timestamps
    end
  end
end
