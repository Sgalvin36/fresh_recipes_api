class AddKrogerIdToIngredients < ActiveRecord::Migration[7.1]
  def change
    add_column :ingredients, :kroger_id, :string
  end
end
