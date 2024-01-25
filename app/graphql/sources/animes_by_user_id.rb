module Sources
  class AnimesByUserId < GraphQL::Dataloader::Source
    def fetch(user_ids)
      records = {}

      User.includes(:animes).where(id: user_ids).each do |user|
        records[user.id] = user.animes.order(:order)
      end

      user_ids.map { |id| records[id] }
    end
  end
end