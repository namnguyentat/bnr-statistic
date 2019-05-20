# frozen_string_literal: true

namespace :db do
  desc 'Clear incognito candidates'
  task remove_duplicate_activities: :environment do
    activity_ids = Activity.all.select do |a|
      Activity.where(activity_id: a.activity_id).count > 1
    end.map(&:activity_id)
    activity_ids.each do |activity_id|
      a = Activity.find_by(activity_id: activity_id)
      a.destroy if a.present?
    end
  end
end
