module Queries
  class FetchAvatars < Queries::BaseQuery
    graphql_name "FetchAvatars"

    argument :query, String, required: false
    argument :gender, String, required: false
    argument :page, Integer, required: false
    argument :user_id, Integer, required: false

    type [Types::AvatarType], null: false

    def resolve(query: nil, gender: nil, page: 1, user_id: nil)
      results = Avatar.all

      if query.present?
        results = Avatar.search_by_name(query)
      end

      if gender.present?
        unless %w(male female).include?(gender)
          return GraphQL::ExecutionError.new("Gender must be male or female")
        end

        results = results.where(gender: gender)
      end

      if user_id.present?
        @user = User.find(user_id)

        unless @user.present?
          return GraphQL::ExecutionError.new("User not found")
        end

        @owned_guids = @user.avatars.pluck(:guid)

        results = results.where.not(guid: @owned_guids)
      end

      results.page(page).per(30)
    end
  end
end