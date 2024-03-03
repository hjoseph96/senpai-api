class AllowConversationsWithNoMatch < ActiveRecord::Migration[7.1]
  def change
    change_column :conversations, :match_id, :integer, :null => true
  end
end
