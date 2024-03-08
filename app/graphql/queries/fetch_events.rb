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
          throw new StandardError("Params user_id is missing")
        end

        results = results.within(@user.lonlat.latitude, @user.lonlat.longitude, event_params[:miles_away])
      end

      results =  results.where('start_date >= ?', event_params[:start_date]) if event_params[:start_date].present?
      results = results.where('end_date > ?', event_params[:end_date]) if event_params[:end_date].present?

      if event_params[:query].present?
        results = results.search_by_title(event_params[:title])
      end

      results.page(page)
    end
  end
end