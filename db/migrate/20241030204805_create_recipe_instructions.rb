class CreateRecipeInstructions < ActiveRecord::Migration[7.1]
  def change
    create_table :recipe_instructions do |t|
      t.string :instruction

      t.timestamps
    end
  end
end
