class AddStatusToParties < ActiveRecord::Migration[7.1]
  def change
    add_column :parties, :status, :integer,default: 0, null: false
    add_index :parties, :status
  end
end
