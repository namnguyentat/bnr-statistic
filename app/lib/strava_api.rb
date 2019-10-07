# frozen_string_literal: true

class StravaApi
  class << self
    def sync_data(user)
      return if user.strava_code.blank?
      refresh_token(user)
      activities = get_activities(user)
      return if activities.blank?
      activities.each do |activity|
        Activity.create_activity(activity, user)
      end
      current_challenge = Challenge.current_challenge
      if current_challenge.present?
        mapping = ChallengeUserMapping.find_by(user: user, challenge: current_challenge)
        mapping.update!(
          total: user.total_activities_in_challenge(current_challenge).map(&:distance).sum
        )
      end
    end

    def get_activities(user)
      after = (Time.current - 10.days).to_i
      url = "/api/v3/athlete/activities?after=#{after}&per_page=100"
      response = connection.get do |req|
        req.url url
        req.headers['Authorization'] = "Bearer #{user.strava_token}"
      end
      user.update!(strava_last_sync_at: Time.current)
      data = JSON.parse(response.body)
      if response.success? && data.is_a?(Array)
        data
      end
    end

    def exchange_token(user)
      response = connection.post do |req|
        req.url '/oauth/token'
        req.body = {
          client_id: Settings.strava_client_id,
          client_secret: Settings.strava_client_secret,
          code: user.strava_code,
          grant_type: 'authorization_code',
          scope: 'read'
        }.to_json
      end
      data = JSON.parse(response.body)
      if response.success? && data['access_token']
        user.update!(
          strava_token: data['access_token'],
          strava_refresh_token: data['refresh_token'],
          strava_athlete_id: data['athlete']['id'],
          strava_last_token_at: Time.current
        )
      end
    end

    def refresh_token(user)
      response = connection.post do |req|
        req.url '/oauth/token'
        req.body = {
          client_id: Settings.strava_client_id,
          client_secret: Settings.strava_client_secret,
          refresh_token: user.strava_refresh_token,
          grant_type: 'refresh_token'
        }.to_json
      end
      data = JSON.parse(response.body)
      if response.success? && data['access_token']
        user.update!(
          strava_token: data['access_token'],
          strava_refresh_token: data['refresh_token'],
          strava_last_token_at: Time.current
        )
      end
    end

    def connection
      Faraday.new(
        url: 'https://www.strava.com',
        headers: {
          'Content-Type': 'application/json'
        }
      )
    end
  end
end
