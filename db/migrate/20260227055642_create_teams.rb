class CreateTeams < ActiveRecord::Migration[7.1]
  def change
    create_table :teams do |t|
      t.string :teamname
      t.string :league
      t.string :logo_url
      t.string :api_football_id
      t.integer :rank
      t.integer :played
      t.integer :wins
      t.integer :draws
      t.integer :losses
      t.integer :goals_for
      t.integer :goals_against
      t.integer :goal_difference
      t.integer :points
      t.string :form
      t.datetime :last_updated
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
