class AddApiFootballIdToFavorites < ActiveRecord::Migration[7.1]
  def change
    add_column :favorites, :api_football_id, :string
    add_index :favorites, :api_football_id
  end
end