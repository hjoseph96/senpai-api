class AddDeletedAtToMatches < ActiveRecord::Migration[7.1]
  def change
    add_column :matches, :deleted_at, :datetime
    add_index :matches, :deleted_at
  end
end
