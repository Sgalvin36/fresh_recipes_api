class CreateRecipeInstructions < ActiveRecord::Migration[7.1]
  def change
    create_table :recipe_instructions do |t|
      t.references :recipe, null: false, foreign_key: true
      t.integer :cooking_style
      t.string :instruction

      t.timestamps
    end
  end
end
