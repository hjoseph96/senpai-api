module Queries
  class FetchAvatars < Queries::BaseQuery
    graphql_name "FetchAvatars"

    argument :query, String, required: false
    argument :page, Integer, required: false

    type [Types::AvatarType], null: false

    def resolve(query: nil, page: 1)
      page = page || 1

      results = Avatar.all

      if query.present?
        results = Avatar.search_by_name(query)
      end

      results.page(page).per(30)
    end
  end
end