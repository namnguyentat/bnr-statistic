class AddDataToChallenges < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :wo_limit, :boolean, default: true
  end
end
