class ChangeStartedAtToEndsAtForBattles < ActiveRecord::Migration[7.1]
  def change
    remove_column :battles, :started_at, :datetime
    add_column :battles, :ends_at, :datetime
  end
end
