module Sources
  class MatchByUserId < GraphQL::Dataloader::Source
    def fetch(user_ids)
      records = {}

      Match.where(user_id: user_ids).group_by(&:user_id).each do |user_id, matches|
        records[user_id] = matches
      end

      user_ids.map { |id| records[id] }
    end
  end
end