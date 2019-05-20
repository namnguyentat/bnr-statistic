class CreateChallenges < ActiveRecord::Migration[5.2]
  def change
    create_table :challenges do |t|
      t.string :name
      t.integer :year
      t.integer :month
      t.integer :min_distance
      t.float :min_pace
      t.integer :min_trail_distance
      t.integer :min_trail_pace
      t.integer :min_trail_elevation_gain

      t.timestamps
    end
  end
end
