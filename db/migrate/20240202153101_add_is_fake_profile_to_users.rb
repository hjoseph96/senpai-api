class AddIsFakeProfileToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :is_fake_profile, :boolean, default: false
    add_index :users, :is_fake_profile
  end
end
