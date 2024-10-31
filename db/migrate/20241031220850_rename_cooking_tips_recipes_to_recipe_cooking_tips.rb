class RenameCookingTipsRecipesToRecipeCookingTips < ActiveRecord::Migration[7.1]
  def change
    rename_table :cooking_tips_recipes, :recipe_cooking_tips
  end
end