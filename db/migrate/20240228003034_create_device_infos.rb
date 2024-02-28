class CreateDeviceInfos < ActiveRecord::Migration[7.1]
  def change
    create_table :device_infos do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :device_type
      t.string :token

      t.timestamps
    end
    remove_column :users, :device_tokens
  end
end
