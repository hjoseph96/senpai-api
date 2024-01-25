module Sources
  class FavoriteMusicsByUserId < GraphQL::Dataloader::Source
    def fetch(user_ids)
      records = {}

      User.includes(:favorite_music).where(id: user_ids).each do |user|
        records[user.id] = user.favorite_music
      end

      user_ids.map { |id| records[id] }
    end
  end
end