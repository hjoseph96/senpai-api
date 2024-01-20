module Queries
  class FetchCharacters < Queries::BaseQuery
    graphql_name "FetchCharacters"

    argument :params, Types::Input::FetchCharactersInputType, required: true
    type [Types::CharacterType], null: false

    def resolve(params:)
      char_params = Hash params

      page = char_params[:page] || 1

      results = Anime.order(popularity: :desc)

      popular_character_ids = results.search_by_genre(char_params[:genre]).map(&:character_ids).flatten
      results = Character.where(id: popular_character_ids)
                         .search_by_full_name(char_params[:character_name])
                         .order(favorites: :desc)

      results.page(page).per(30)
    end
  end
end