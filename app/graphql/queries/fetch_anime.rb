module Queries
    class FetchAnime < Queries::BaseQuery
      graphql_name "FetchAnime"

      argument :params, Types::Input::AnimeInputType, required: true
      type [Types::AnimeType], null: false
  
      def resolve(params:)
        anime_params = Hash params

        page = anime_params[:page] || 1

        results = Anime.order(popularity: :desc).page(page)
        results = Anime.search_by_title(anime_params[:title]).order(popularity: :desc).page(page) if anime_params[:title].present?
        results = Anime.search_by_genre(anime_params[:genre]).order(popularity: :desc).page(page) if anime_params[:genre].present?

        results
      end
    end
  end