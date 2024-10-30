class CreateJoinTableRecipeCookingTip < ActiveRecord::Migration[7.1]
  def change
    create_join_table :recipes, :cooking_tips do |t|
      # t.index [:recipe_id, :cooking_tip_id]
      # t.index [:cooking_tip_id, :recipe_id]
    end
  end
end
