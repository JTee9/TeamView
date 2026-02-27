class CreatePlayers < ActiveRecord::Migration[7.1]
  def change
    create_table :players do |t|
      t.string :name
      t.string :position
      t.string :nationality
      t.string :market_value
      t.integer :shirt_number
      t.integer :age
      t.string :api_football_id
      t.datetime :last_updated
      t.references :team, null: false, foreign_key: true

      t.timestamps
    end
  end
end
