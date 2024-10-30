class CreateRecipeUtensils < ActiveRecord::Migration[7.1]
  def change
    create_table :recipe_utensils do |t|

      t.timestamps
    end
  end
end
