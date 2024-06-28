module Queries
  class FetchAvatars < Queries::BaseQuery
    graphql_name "FetchAvatars"

    argument :query, String, required: false
    argument :gender, String, required: false
    argument :page, Integer, required: false

    type [Types::AvatarType], null: false

    def resolve(query: nil, gender: nil, page: 1)
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

      results.page(page).per(30)
    end
  end
end