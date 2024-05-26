class AddAwaitingMatchToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :awaiting_match, :boolean
    add_index :users, :awaiting_match
  end
end
