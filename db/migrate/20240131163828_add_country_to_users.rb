class AddCountryToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :country, :string
    add_index :users, :country
  end
end
