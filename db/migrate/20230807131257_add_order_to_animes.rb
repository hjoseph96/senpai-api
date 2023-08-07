class AddOrderToAnimes < ActiveRecord::Migration[7.0]
  def change
    add_column :user_animes, :order, :integer
    add_index :user_animes, :order
  end
end
