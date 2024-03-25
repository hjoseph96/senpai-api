module Queries
  class FetchEvents < Queries::BaseQuery
    graphql_name "FetchEvents"

    type [Types::EventType], null: false
    argument :params, Types::Input::SearchEventInputType, required: true


    def resolve(params:)
      event_params = Hash params

      page = event_params[:page] || 1

      results = Event.order(created_at: :desc)

      if event_params[:miles_away].present?
        if event_params[:user_id].present?
          @user = User.find(event_params[:user_id])
        else
          return GraphQL::ExecutionError.new("Params user_id is missing")
        end

        results = results.within(@user.lonlat.latitude, @user.lonlat.longitude, event_params[:miles_away])
      end

      results =  results.where('start_date >= ?', event_params[:start_date]) if event_params[:start_date].present?
      results = results.where('end_date >= ?', event_params[:end_date]) if event_params[:end_date].present?

      if event_params[:payment_required].nil?
        results = results.where(payment_required: event_params[:payment_required])
      end

      unless event_params[:cosplay_required].present?
        unless %w(no optional required).include?(event_params[:cosplay_required])
          return GraphQL::ExecutionError.new("Invalid cosplay_required provided.")
        end

        results = results.where(cosplay_required: event_params[:cosplay_required])
      end

      if event_params[:query].present?
        results = results.search_by_title(event_params[:query])
      end

      if event_params[:host_rating].present?
        results = results.joins(host: :reviews)
                         .where('reviews.review_type = ?', 1) # reviews as host only
                         .group('events.id')
                         .having("AVG(reviews.score) > #{event_params[:host_rating]}")
      end

      results.page(page)
    end
  end
end