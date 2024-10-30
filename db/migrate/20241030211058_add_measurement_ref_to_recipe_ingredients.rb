class AddMeasurementRefToRecipeIngredients < ActiveRecord::Migration[7.1]
  def change
    add_reference :recipe_ingredients, :measurement, null: false, foreign_key: true
  end
end
