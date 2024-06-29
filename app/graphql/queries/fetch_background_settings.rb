module Queries
  class FetchBackgroundSettings < Queries::BaseQuery
    graphql_name "FetchBackgroundSettings"

    argument :user_id, ID, required: true
    argument :page, Integer, required: false

    type [Types::BackgroundSettingType], null: false

    def resolve(user_id:, page: 1)
      @user = User.find(user_id)

      unless @user.present?
        return GraphQL::ExecutionError.new("User with provided ID cannot be found")
      end

      @user.background_settings
    end
  end
end