class AddBirthdayToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :birthday, :datetime
    add_index :users, :birthday
  end
end
