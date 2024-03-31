class DefaultCompletedFalseForTournaments < ActiveRecord::Migration[7.1]
  def change
    change_column :tournaments, :completed, :boolean, default: false, null: false
  end
end
