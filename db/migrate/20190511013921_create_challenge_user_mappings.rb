class CreateChallengeUserMappings < ActiveRecord::Migration[5.2]
  def change
    create_table :challenge_user_mappings do |t|
      t.references :user, foreign_key: true
      t.references :challenge, foreign_key: true
      t.integer :target
      t.integer :total

      t.timestamps
    end
  end
end
