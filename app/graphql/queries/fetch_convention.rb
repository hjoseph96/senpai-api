module Queries
  class FetchConvention < Queries::BaseQuery
    graphql_name "FetchConvention"

    argument :convention_id, ID, required: true
    type Types::ConventionType, null: false

    def resolve(convention_id:)
      @convention = Convention.find(convention_id)
    end
  end
end