class AddConversationIdToMessages < ActiveRecord::Migration[7.0]
  def change
    add_reference :messages, :conversation, null: false, foreign_key: true, type: :uuid
  end
end
