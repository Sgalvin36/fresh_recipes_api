class CreateRecipes < ActiveRecord::Migration[7.1]
  def change
    create_table :recipes do |t|
      t.string :recipe_name
      t.float :total_price
      t.string :image
      t.integer :serving_size

      t.timestamps
    end
  end
end
