class CreateRecipeCookingTips < ActiveRecord::Migration[7.1]
  def change
    create_table :recipe_cooking_tips do |t|

      t.timestamps
    end
  end
end
