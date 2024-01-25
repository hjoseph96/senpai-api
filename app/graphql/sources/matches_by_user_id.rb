module Sources
  class MatchesByUserId < GraphQL::Dataloader::Source
    def fetch(user_ids)
      records = {}

      User.includes(:matches).where(id: user_ids).each do |user|
        records[user.id] = user.matches
      end

      user_ids.map { |id| records[id] }
    end
  end
end