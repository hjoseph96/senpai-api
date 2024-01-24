module Sources
  class MatcheeByMatchId < GraphQL::Dataloader::Source
    def fetch(match_ids)
      records = {}

      Match.includes(:matchee).where(id: match_ids).each do |match|
        records[match.id] = match.matchee
      end

      match_ids.map { |id| records[id] }
    end
  end
end