module Sources
  class MessagesByConversationId < GraphQL::Dataloader::Source
    def fetch(conversation_ids)
      records = {}

      Conversation.includes(:messages).where(id: conversation_ids).each do |conversation|
        records[conversation.id] = conversation.messages.includes(attachment_attachment: :blob).order(created_at: :desc)
      end

      conversation_ids.map { |id| records[id] }
    end
  end
end