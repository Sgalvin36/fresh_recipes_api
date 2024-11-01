class CreateRecipeCookware < ActiveRecord::Migration[7.1]
  def change
    create_table :recipe_cookwares do |t|
      t.references :recipe, null: false, foreign_key: true
      t.references :cookware, null: false, foreign_key: true

      t.timestamps
    end
  end
end
