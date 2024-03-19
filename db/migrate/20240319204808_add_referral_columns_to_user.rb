class AddReferralColumnsToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :referral_code, :uuid, default: 'uuid_generate_v4()'
  end
end
