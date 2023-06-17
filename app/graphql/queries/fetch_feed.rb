module Queries
    class FetchFeed < Queries::BaseQuery
        graphql_name "FetchFeed"

        argument :user_id, ID, required: true
        argument :page, Integer, required: false

        type [Types::UserType], null: false

      def resolve(user_id:, page:)
        page = page || 1

        results = FeedLoader.create_feed(user_id: user_id).page(page)

        results
      end
    end
end