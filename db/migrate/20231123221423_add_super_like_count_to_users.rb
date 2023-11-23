class AddSuperLikeCountToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :super_like_count, :integer, default: 5
    add_index :users, :super_like_count
  end
end
