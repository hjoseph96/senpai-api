module Queries
  class FetchSticker < Queries::BaseQuery
    graphql_name "FetchSticker"

    argument :sticker_id, ID, required: true
    type Types::StickerType, null: false

    def resolve(sticker_id:)
      result = Sticker.find(sticker_id)
    end
  end
end
