class AddUserIdToBlocks < ActiveRecord::Migration[7.1]
  def change
    add_reference :blocks, :user, null: false, foreign_key: true
  end
end
