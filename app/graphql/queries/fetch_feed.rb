module Queries
    class FetchFeed < Queries::BaseQuery
        graphql_name "FetchFeed"

        argument :user_id, Integer, required: true
        argument :page, Integer, required: false

        type [Types::UserType], null: false

      def resolve(params:)
        page = params[:page] || 1

        results = FeedLoader.create_feed(params[:user_id]).page(page)

        { results: results, page: page }
      end
    end
end