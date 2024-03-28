module Queries
  class FetchCharacters < Queries::BaseQuery
    graphql_name "FetchCharacters"

    argument :params, Types::Input::FetchCharactersInputType, required: true
    type [Types::CharacterType], null: false

    def resolve(params:)
      char_params = Hash params

      page = char_params[:page] || 1

      results = Character.order(favorites: :desc)

      if params[:character_name].present?
        results = Character.order(favorites: :desc)
                             .search_by_full_name(char_params[:character_name])
      end

      if params[:genre].present?
        popular_character_ids = Anime.order(popularity: :desc).search_by_genre(char_params[:genre]).map(&:character_ids).flatten
        results = Character.where(id: popular_character_ids).order(favorites: :desc)
      end

      results.page(page).per(30)
    end
  end
end