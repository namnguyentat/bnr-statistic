class AddDnfDataToChallenges < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :dnf_money, :integer, default: 250_000
    add_column :challenges, :miss_target_money, :integer, default: 0
  end
end
