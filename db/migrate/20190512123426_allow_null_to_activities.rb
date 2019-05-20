# frozen_string_literal: true

class AllowNullToActivities < ActiveRecord::Migration[5.2]
  def change
    change_column :activities, :pace, :float, null: true
    change_column :activities, :race_pace, :float, null: true
  end
end
