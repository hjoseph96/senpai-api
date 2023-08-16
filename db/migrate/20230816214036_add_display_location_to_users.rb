class AddDisplayLocationToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :display_city, :string
    add_column :users, :display_state, :string
  end
end
