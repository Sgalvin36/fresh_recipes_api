class CreateJoinTableRecipeCookware < ActiveRecord::Migration[7.1]
  def change
    create_join_table :recipes, :cookware do |t|
      # t.index [:recipe_id, :cookware_id]
      # t.index [:cookware_id, :recipe_id]
    end
  end
end