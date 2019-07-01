# frozen_string_literal: true

class Activity < ApplicationRecord
  belongs_to :user

  validates :activity_id, uniqueness: true
  validates :kind, presence: true
  validates :name, presence: true
  validates :timezone, presence: true
  validates :start_date_local, presence: true
  validates :distance, presence: true
  validates :elapsed_time, presence: true
  validates :moving_time, presence: true
  validates :year, presence: true
  validates :month, presence: true
  validates :week, presence: true
  validates :data, presence: true

  scope :order_newest, lambda {
    order(activity_id: :DESC)
  }

  scope :kind_run, lambda {
    where(kind: 'Run')
  }

  def distance_format
    return unless distance > 0

    "#{(distance.to_f / 1000).floor(2)} km"
  end

  def pace_format
    return unless kind == 'Run' && distance > 0 && moving_time > 0 && pace.present?

    min = pace.to_i
    sec = ((pace - min) * 60).to_i
    sec = "0#{sec}" if sec < 10
    "#{min}:#{sec}"
  end

  def brief_information
    "#{start_date_local.strftime('%d-%m')} - #{distance_format} - #{pace_format}"
  end

  def self.create_activity(data, user)
    return if Activity.exists?(activity_id: data['id'])
    return unless data['distance'] > 0

    activity = Activity.new(
      user: user,
      kind: data['type'],
      activity_id: data['id'],
      name: data['name'],
      timezone: data['timezone'],
      start_date_local: data['start_date'].to_time,
      distance: data['distance'],
      elapsed_time: data['elapsed_time'],
      moving_time: data['moving_time'],
      total_elevation_gain: data['total_elevation_gain'],
      data: data.to_json
    )
    if activity.kind == 'Run' && activity.distance > 0
      activity.pace = (activity.moving_time.to_f / 60) / (activity.distance.to_f / 1000)
      activity.race_pace = (activity.elapsed_time.to_f / 60) / (activity.distance.to_f / 1000)
    end
    activity.year = activity.start_date_local.year
    activity.month = activity.start_date_local.month
    activity.week = activity.start_date_local.week_of_month
    activity.save!
  end
end
