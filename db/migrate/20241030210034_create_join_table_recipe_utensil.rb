class CreateJoinTableRecipeUtensil < ActiveRecord::Migration[7.1]
  def change
    create_join_table :recipes, :utensils do |t|
      # t.index [:recipe_id, :utensil_id]
      # t.index [:utensil_id, :recipe_id]
    end
  end
end
