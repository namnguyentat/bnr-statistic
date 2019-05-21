class AddDataToChallengeUserMappings < ActiveRecord::Migration[5.2]
  def change
    change_column :challenge_user_mappings, :total, :float
  end
end
