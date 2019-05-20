# frozen_string_literal: true

class CreateActivities < ActiveRecord::Migration[5.2]
  def change
    create_table :activities do |t|
      t.references :user, foreign_key: true
      t.string :name, null: false
      t.string :kind, null: false
      t.string :activity_id, null: false, index: true
      t.string :timezone, null: false
      t.datetime :start_date_local, null: false
      t.integer :distance, null: false
      t.integer :elapsed_time, null: false
      t.integer :moving_time, null: false
      t.float :pace, null: false
      t.float :race_pace, null: false
      t.integer :year, null: false
      t.integer :month, null: false
      t.integer :week, null: false
      t.integer :total_elevation_gain, null: false
      t.text :data, null: false

      t.timestamps
    end
  end
end
