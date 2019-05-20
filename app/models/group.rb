# frozen_string_literal: true

class Group < ApplicationRecord
  has_many :group_user_mappings, dependent: :destroy
  has_many :users, through: :group_user_mappings

  validates :name, presence: true

  scope :order_newest, lambda {
    order(id: :DESC)
  }
end
