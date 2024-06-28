class AddGenderToAvatars < ActiveRecord::Migration[7.1]
  def change
    add_column :avatars, :gender, :integer
    add_index :avatars, :gender
  end
end
