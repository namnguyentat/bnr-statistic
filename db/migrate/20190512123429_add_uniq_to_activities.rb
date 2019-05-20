# frozen_string_literal: true

class AddUniqToActivities < ActiveRecord::Migration[5.2]
  def change
    remove_index :activities, :activity_id
    add_index :activities, :activity_id, unique: true
  end
end
