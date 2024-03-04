class AddDisbandedToParties < ActiveRecord::Migration[7.1]
  def change
    add_column :parties, :disbanded, :boolean
  end
end
