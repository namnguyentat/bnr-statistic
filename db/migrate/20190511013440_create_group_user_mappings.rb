class CreateGroupUserMappings < ActiveRecord::Migration[5.2]
  def change
    create_table :group_user_mappings do |t|
      t.references :user, foreign_key: true
      t.references :group, foreign_key: true

      t.timestamps
    end
  end
end
