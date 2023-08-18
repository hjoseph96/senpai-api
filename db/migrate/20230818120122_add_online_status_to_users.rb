class AddOnlineStatusToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :online_status, :integer, default: 1 # start offline
    add_index :users, :online_status
  end
end
