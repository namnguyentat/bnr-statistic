class AddStravaRefreshTokenToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :strava_refresh_token, :string
  end
end
