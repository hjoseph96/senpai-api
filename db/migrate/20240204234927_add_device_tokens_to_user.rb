class AddDeviceTokensToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :device_tokens, :text, array: true, default: []
  end
end
