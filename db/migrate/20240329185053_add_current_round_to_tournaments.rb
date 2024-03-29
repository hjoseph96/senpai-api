class AddCurrentRoundToTournaments < ActiveRecord::Migration[7.1]
  def change
    add_column :tournaments, :current_round, :integer
  end
end
