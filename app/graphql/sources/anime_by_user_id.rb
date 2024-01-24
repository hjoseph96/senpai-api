module Sources
  class AnimeByUserId < GraphQL::Dataloader::Source
    def fetch(user_ids)
      records = {}

      UserAnime.where(user_id: user_ids).group_by(&:user_id).each do |user_id, animes|
        records[user_id] = animes.sort_by(&:order).map(&:anime)
      end

      user_ids.map { |id| records[id] }
    end
  end
end