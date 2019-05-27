# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  validates :name, presence: true

  has_many :activities, dependent: :destroy
  has_many :group_user_mappings, dependent: :destroy
  has_many :groups, through: :group_user_mappings
  has_many :challenge_user_mappings, dependent: :destroy
  has_many :challenges, through: :challenge_user_mappings

  scope :order_newest, lambda {
    order(id: :DESC)
  }
  scope :team_bnr, lambda {
    where(team: 'BNR')
  }

  def total_activities_in_challenge(challenge)
    result = activities.where(kind: 'Run')
                       .where(start_date_local: (challenge.start_date.beginning_of_day..challenge.end_date.end_of_day))
                       .order_newest
    result = result.select do |activity|
      (activity.distance >= challenge.min_distance && activity.pace <= challenge.min_pace) ||
        (activity.distance >= challenge.min_trail_distance && activity.pace <= challenge.min_trail_pace && activity.total_elevation_gain >= challenge.min_trail_elevation_gain)
    end
    result = result.select.with_index do |activity, index|
      pre = result[index - 1]
      next if pre && pre.start_date_local.to_date == activity.start_date_local.to_date && pre.distance > activity.distance
      pos = result[index + 1]
      next if pos && pos.start_date_local.to_date == activity.start_date_local.to_date && pre.distance > activity.distance
      true
    end
    result
  end

  def team_bnr?
    team == 'BNR'
  end
end
