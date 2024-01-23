module Sources
  class FavoriteMusicByUserId < GraphQL::Dataloader::Source
    def fetch(user_ids)
      records = {}

      FavoriteMusic.where(user_id: user_ids).group_by(&:user_id).each do |user_id, favorite_musics|
        records[user_id] = favorite_musics.first
      end

      user_ids.map { |id| records[id] }
    end
  end
end