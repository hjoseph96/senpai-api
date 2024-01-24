module Sources
  class RecommendationByMessageId < GraphQL::Dataloader::Source
    def fetch(message_ids)
      records = {}

      Message.includes(:recommendation).where(id: message_ids).each do |message|
        records[message.id] = message.recommendation
      end

      message_ids.map { |id| records[id] }
    end
  end
end