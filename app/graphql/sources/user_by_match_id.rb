module Sources
  class UserByMatchId < GraphQL::Dataloader::Source
    def fetch(match_ids)
      records = {}

      Match.includes(:user).where(id: match_ids).each do |match|
        records[match.id] = match.user
      end

      match_ids.map { |id| records[id] }
    end
  end
end