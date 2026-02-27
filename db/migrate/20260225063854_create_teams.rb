class CreateTeams < ActiveRecord::Migration[7.1]
  def change
    create_table :teams do |t|
      t.string :teamname
      t.string :division
      t.string :captain
      t.string :motto
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
