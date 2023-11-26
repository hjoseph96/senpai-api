class AddBanAndWarningsToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :banned, :boolean, default: false
    add_column :users, :warning_count, :integer, default: 0
  end
end
