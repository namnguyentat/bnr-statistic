# frozen_string_literal: true

class AddStravaToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :is_admin, :boolean
    add_column :users, :strava_code, :string
    add_column :users, :strava_token, :string
    add_column :users, :strava_athlete_id, :string
    add_column :users, :strava_last_sync_at, :datetime
    add_column :users, :strava_last_token_at, :datetime
  end
end
