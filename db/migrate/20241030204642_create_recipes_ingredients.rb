class CreateRecipesIngredients < ActiveRecord::Migration[7.1]
  def change
    create_table :recipes_ingredients do |t|
      t.float :quantity

      t.timestamps
    end
  end
end
