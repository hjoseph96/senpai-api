class AddPriceToAvatars < ActiveRecord::Migration[7.1]
  def change
    add_column :avatars, :price, :integer
    add_index :avatars, :price
  end
end
