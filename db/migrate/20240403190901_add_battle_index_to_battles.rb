class AddBattleIndexToBattles < ActiveRecord::Migration[7.1]
  def change
    add_column :battles, :battle_index, :integer
    add_index :battles, :battle_index
  end
end
