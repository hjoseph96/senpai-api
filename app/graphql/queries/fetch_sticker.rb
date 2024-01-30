module Queries
  class FetchSticker < Queries::BaseQuery
    graphql_name "FetchSticker"

    argument :sticker_id, ID, required: true
    type Types::StickerType, null: false

    def resolve(sticker_id:)
      unless context[:ready?]
        raise GraphQL::ExecutionError.new('Unauthorized Error', options: { status: :unauthorized, code: 401 })
      end

      result = Sticker.find(sticker_id)
    end
  end
end
