class CreateReferrals < ActiveRecord::Migration[7.1]
  def change
    create_table :referrals do |t|
      t.integer :referer_id
      t.integer :referred_id

      t.timestamps
    end
  end
end
