module Queries
    class FetchFeed < Queries::BaseQuery
        graphql_name "FetchFeed"

        argument :user_id, ID, required: true
        argument :miles_away, Integer, required: true
        argument :page, Integer, required: false

        type [Types::UserType], null: false

        def resolve(user_id:, miles_away:, page: 1)
          feed = Rails.cache.read("#{user_id}-FEED")

          if feed.present?
            results = User.where(id: feed)
          else
            results = FeedLoader.create_feed(user_id: user_id, distance_in_miles: miles_away)

            Rails.cache.write("#{user_id}-FEED", results.pluck(:id))
          end

          results.page(page).per(25)
        end
    end
end