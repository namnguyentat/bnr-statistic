class AddDateToChallenges < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :start_date, :date
    add_column :challenges, :end_date, :date
    change_column :challenges, :min_pace, :integer
  end
end
