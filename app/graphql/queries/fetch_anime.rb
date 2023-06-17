module Queries
    class FetchAnime < Queries::BaseQuery
      graphql_name "FetchAnime"

      argument :params, Types::Input::AnimeInputType, required: true
      type [Types::AnimeType], null: false
  
      def resolve(params:)
        anime_params = Hash params

        page = anime_params[:page] || 1

        results = Anime.order(popularity: :desc).page(page)
        results = Anime.search_by_title(params[:title]).order(popularity: :desc).page(page) if params[:title].present?

        results
      end
    end
  end