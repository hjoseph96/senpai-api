module Sources
  class ConversationByMatchId < GraphQL::Dataloader::Source
    def fetch(match_ids)
      records = {}

      Match.includes(:conversation).where(id: match_ids).each do |match|
        records[match.id] = match.conversation
      end

      match_ids.map { |id| records[id] }
    end
  end
end