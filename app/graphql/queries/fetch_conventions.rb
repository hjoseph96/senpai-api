module Queries
  class FetchConventions< Queries::BaseQuery
    graphql_name "FetchConventions"

    type [Types::ConventionType], null: false
    argument :params, Types::Input::SearchEventInputType, required: true


    def resolve(params:)
      convention_params = Hash params

      page = convention_params[:page] || 1

      results = Convention.order(created_at: :desc)

      if convention_params[:miles_away].present?
        if convention_params[:user_id].present?
          @user = User.find(convention_params[:user_id])
        else
          throw new StandardError("Params user_id is missing")
        end

        results = results.within(@user.lonlat.latitude, @user.lonlat.longitude, convention_params[:miles_away])
      end

      if convention_params[:start_date].present?
        results = results.where(start_date: DateTime.now...convention_params[:start_date])
      end

      results = results.where('end_date > ?', convention_params[:end_date]) if convention_params[:end_date].present?

      if convention_params[:query].present?
        results = results.search_by_title(event_params[:title])
      end

      results.page(page)
    end
  end
end