class CreateInfluencers < ActiveRecord::Migration[7.0]
  def change
    create_table :influencers, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, on_delete: :cascade
      t.integer :referral_count

      t.timestamps
    end
    add_index :influencers, :referral_count
  end
end
