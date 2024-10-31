class CreateCookware < ActiveRecord::Migration[7.1]
  def change
    create_table :cookware do |t|
      t.string :name

      t.timestamps
    end
  end
end