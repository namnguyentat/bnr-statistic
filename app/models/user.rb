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
    if challenge.wo_limit
      result = result.select.with_index do |activity, index|
        pre = result[index - 1]
        next if pre && pre.start_date_local.to_date == activity.start_date_local.to_date && pre.distance > activity.distance

        pos = result[index + 1]
        next if pos && pos.start_date_local.to_date == activity.start_date_local.to_date && pos.distance > activity.distance

        true
      end
    end
    result
  end

  def total_money_in_challenge(challenge, activities)
    money = 0
    hm = activities.select { |a| a.distance >= 21_097 }.count
    w1_wo = activities.select { |a| a.week == 1 }.map(&:start_date_local).map(&:to_date).uniq.count
    w2_wo = activities.select { |a| a.week == 2 }.map(&:start_date_local).map(&:to_date).uniq.count
    w3_wo = activities.select { |a| a.week == 3 }.map(&:start_date_local).map(&:to_date).uniq.count
    w4_wo = activities.select { |a| a.week == 4 }.map(&:start_date_local).map(&:to_date).uniq.count
    w5_wo = activities.select { |a| a.week == 5 }.map(&:start_date_local).map(&:to_date).uniq.count
    w6_wo = activities.select { |a| a.week == 6 }.map(&:start_date_local).map(&:to_date).uniq.count
    total_km = (activities.map(&:distance).sum.to_f / 1000).to_i
    target = ChallengeUserMapping.find_by(user: self, challenge: challenge).try(:target).to_i
    wo_money = challenge.wo_money.to_i
    hm_money = challenge.hm_money.to_i
    km_money = challenge.km_money.to_i
    w1 = challenge.w1.to_i
    w2 = challenge.w2.to_i
    w3 = challenge.w3.to_i
    w4 = challenge.w4.to_i
    w5 = challenge.w5.to_i
    w6 = challenge.w6.to_i
    money += (w1 - w1_wo) * wo_money if w1_wo < w1
    money += (w2 - w2_wo) * wo_money if w2_wo < w2
    money += (w3 - w3_wo) * wo_money if w3_wo < w3
    money += (w4 - w4_wo) * wo_money if w4_wo < w4
    money += (w5 - w5_wo) * wo_money if w5_wo < w5
    money += (w6 - w6_wo) * wo_money if w6_wo < w6
    money += hm_money if hm < 1
    if km_money > 0
      money += (target - total_km) * km_money if total_km < target
    end
    if challenge.miss_target_money > 0
      money += challenge.miss_target_money if total_km < target
    end
    money = challenge.dnf_money if money > challenge.dnf_money
    money if money > 0
  end

  def team_bnr?
    team == 'BNR'
  end
end
