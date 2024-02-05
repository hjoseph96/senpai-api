class AddActiveDisplayBoolsToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :is_displaying_active, :boolean, default: true
    add_column :users, :is_displaying_recently_active, :boolean, default: true
  end
end
