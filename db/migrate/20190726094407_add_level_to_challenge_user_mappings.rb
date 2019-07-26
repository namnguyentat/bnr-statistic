class AddLevelToChallengeUserMappings < ActiveRecord::Migration[5.2]
  def change
    add_column :challenge_user_mappings, :level, :integer, default: 3
  end
end
