class AddMeasurementRefToRecipeIngredients < ActiveRecord::Migration[7.1]
  def change
    add_reference :recipe_ingredients, :measurement_id, null: false, foreign_key: true
    add_reference :recipe_ingredients, :recipe_id, null: false, foreign_key: true
    add_reference :recipe_ingredients, :ingredient_id, null: false, foreign_key: true
  end
end
