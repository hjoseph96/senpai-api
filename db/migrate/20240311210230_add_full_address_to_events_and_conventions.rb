class AddFullAddressToEventsAndConventions < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :full_address, :string, null: false
    add_column :conventions, :full_address, :string, null: false
  end
end
