module Queries
    class FetchAnime < Queries::BaseQuery
      graphql_name "FetchAnime"

      argument :params, Types::Input::AnimeInputType, required: true
      type [Types::AnimeType], null: false
  
      def resolve(params:)
        unless context[:ready?]
          raise GraphQL::ExecutionError.new('Unauthorized Error', options: { status: :unauthorized, code: 401 })
        end

        anime_params = Hash params

        page = anime_params[:page] || 1

        results = Anime.order(popularity: :desc).page(page)
        if anime_params[:genres].present?
          results = results.search_by_genre(anime_params[:genres]).order(popularity: :desc).page(page)
        end

        if anime_params[:title].present?
          results = results.search_by_title(anime_params[:title]).order(popularity: :desc).page(page)
        end

        results
      end
    end
  end