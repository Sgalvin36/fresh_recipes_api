class CreateJoinTableRecipeUtensil < ActiveRecord::Migration[7.1]
  def change
    create_join_table :recipes, :cooking_utensils do |t|
      # t.index [:recipe_id, :cooking_utensil_id]
      # t.index [:cooking_utensil_id, :recipe_id]
    end
  end
end

# I think we should rename `cooking_utensil` to just `utensil` to match our other naming conventions.