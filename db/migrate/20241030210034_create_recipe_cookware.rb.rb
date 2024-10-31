class CreateRecipeCookware < ActiveRecord::Migration[7.1]
  def change
    create_table :recipe_cookware, id: false do |t|
      t.bigint :recipe_id, null: false
      t.bigint :cookware_id, null: false
      t.index :recipe_id
      t.index :cookware_id
    end
  end
end