module Sources
  class CharactersByAnimeId < GraphQL::Dataloader::Source
    def fetch(anime_ids)
      records = {}

      Anime.includes(:characters).where(id: anime_ids).each do |anime|
        records[anime.id] = anime.characters.order(favorites: :desc)
      end

      anime_ids.map { |id| records[id] }
    end
  end
end