module Sources
  class MatchByConversationId < GraphQL::Dataloader::Source
    def fetch(conversation_ids)
      records = {}

      Conversation.includes(:match).where(id: conversation_ids).each do |conversation|
        records[conversation.id] = conversation.match
      end

      conversation_ids.map { |id| records[id] }
    end
  end
end