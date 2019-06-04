class UpdateChallenges < ActiveRecord::Migration[5.2]
  def change
    add_column :challenges, :w1, :integer, null: false, default: 0
    add_column :challenges, :w2, :integer, null: false, default: 0
    add_column :challenges, :w3, :integer, null: false, default: 0
    add_column :challenges, :w4, :integer, null: false, default: 0
    add_column :challenges, :w5, :integer, null: false, default: 0
    add_column :challenges, :w6, :integer, null: false, default: 0
    add_column :challenges, :wo_money, :integer, null: false, default: 0
    add_column :challenges, :hm_money, :integer, null: false, default: 0
    add_column :challenges, :km_money, :integer, null: false, default: 0
  end
end
