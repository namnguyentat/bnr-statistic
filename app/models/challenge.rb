# frozen_string_literal: true

class Challenge < ApplicationRecord
  has_many :challenge_user_mappings, dependent: :destroy
  has_many :users, through: :challenge_user_mappings

  validates :name, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :min_distance, presence: true
  validates :min_pace, presence: true
  validates :min_trail_distance, presence: true
  validates :min_trail_pace, presence: true

  scope :order_newest, lambda {
    order(id: :DESC)
  }
end