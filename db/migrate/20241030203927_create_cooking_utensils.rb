class CreateCookingUtensils < ActiveRecord::Migration[7.1]
  def change
    create_table :cooking_utensils do |t|
      t.string :name

      t.timestamps
    end
  end
end