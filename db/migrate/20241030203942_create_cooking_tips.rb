class CreateCookingTips < ActiveRecord::Migration[7.1]
  def change
    create_table :cooking_tips do |t|
      t.string :tip

      t.timestamps
    end
  end
end
