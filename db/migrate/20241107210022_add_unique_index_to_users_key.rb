class AddUniqueIndexToUsersKey < ActiveRecord::Migration[7.1]
  def change
    add_index :users, :key, unique: true
  end
end
