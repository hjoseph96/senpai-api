class AddConversationIdToJoinRequests < ActiveRecord::Migration[7.1]
  def change
    add_column :join_requests, :conversation_id, :uuid, null: true
  end
end
