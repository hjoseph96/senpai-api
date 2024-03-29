class AddCompletedToTournaments < ActiveRecord::Migration[7.1]
  def change
    add_column :tournaments, :completed, :boolean
    add_index :tournaments, :completed
  end
end
