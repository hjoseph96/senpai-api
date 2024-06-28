class AddProductIdToAvatars < ActiveRecord::Migration[7.1]
  def change
    add_column :avatars, :product_id, :string
  end
end
