class RemoveTeamIdFromFavorites < ActiveRecord::Migration[7.1]
  def change
    # First, drop the foreign key constraint
    remove_foreign_key :favorites, :teams if foreign_key_exists?(:favorites, :teams)
    
    # Then remove the index
    remove_index :favorites, :team_id if index_exists?(:favorites, :team_id)
    
    # Finally, remove the column
    remove_column :favorites, :team_id, :bigint
  end
end