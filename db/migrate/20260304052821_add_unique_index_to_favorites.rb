class AddUniqueIndexToFavorites < ActiveRecord::Migration[7.1]
  def change
    add_index :favorites, [:user_id, :league], unique: true
  end
end
