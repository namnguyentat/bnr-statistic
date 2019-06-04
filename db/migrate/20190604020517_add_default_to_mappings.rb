class AddDefaultToMappings < ActiveRecord::Migration[5.2]
  def change
    change_column_default :challenge_user_mappings, :target, 0
    change_column_default :challenge_user_mappings, :total, 0
  end
end
