class CreateRecipeCookingTips < ActiveRecord::Migration[7.1]
  def change
    create_table :recipe_cooking_tips do |t|
      t.references :cooking_tip, null: false, foreign_key: true
      t.references :recipe, null: false, foreign_key: true

      t.timestamps
    end
  end
end