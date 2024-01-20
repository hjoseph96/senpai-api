class AddDeletedAtToAssociations < ActiveRecord::Migration[7.1]
  def change
    add_column :user_animes, :deleted_at, :datetime
    add_column :user_likes, :deleted_at, :datetime
    add_column :user_conversations, :deleted_at, :datetime
    add_column :galleries, :deleted_at, :datetime
    add_column :photos, :deleted_at, :datetime
    add_column :favorite_musics, :deleted_at, :datetime
    add_column :messages, :deleted_at, :datetime
    add_column :verify_requests, :deleted_at, :datetime
    add_column :recommendations, :deleted_at, :datetime
    add_column :influencers, :deleted_at, :datetime

    add_index :user_animes, :deleted_at
    add_index :user_likes, :deleted_at
    add_index :user_conversations, :deleted_at
    add_index :galleries, :deleted_at
    add_index :photos, :deleted_at
    add_index :favorite_musics, :deleted_at
    add_index :messages, :deleted_at
    add_index :verify_requests, :deleted_at
    add_index :recommendations, :deleted_at
    add_index :influencersx, :deleted_at
  end
end
