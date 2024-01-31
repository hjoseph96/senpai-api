module Queries
    class FetchFeed < Queries::BaseQuery
        graphql_name "FetchFeed"

        argument :params, Types::Input::FetchFeedInput, required: true

        type [Types::UserType], null: false

        def resolve(params:)
          feed_params = Hash  params
          feed  = Rails.cache.read("#{feed_params[:user_id]}-FEED")

          if feed.present? && !feed_params[:refresh].present?
            results = User.where(id: feed)
          else
            results = FeedLoader.create_feed(
              user_id: feed_params[:user_id],
              distance_in_miles: feed_params[:miles_away],
              anime_ids: feed_params[:anime_ids].present? ? feed_params[:anime_ids] : []
            )

            Rails.cache.write("#{feed_params[:user_id]}-FEED", results.pluck(:id))
          end

          return [] unless results.count > 0

          if feed_params[:min_age].present? && feed_params[:max_age].present?
            min_date = feed_params[:min_age].years.ago.to_date
            max_date = feed_params[:max_age].years.ago.to_date
            results = results.where(birthday: max_date..min_date)
          end

          return  [] unless results.present?

          results = results.where.not(bio: '') if feed_params[:bio].present?
          results = results.where(verified: feed_params[:verified]) if feed_params[:verified].present?

          if feed_params[:anime_ids].present?
            results = results.joins(:animes).where({ animes: { id: feed_params[:anime_ids] } })
          end

          @user = User.find(feed_params[:user_id]).appear

          page = feed_params[:page] || 1

          results.page(page).per(25)
        end
    end
end