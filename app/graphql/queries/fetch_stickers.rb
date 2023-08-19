module Queries
    class FetchStickers < Queries::BaseQuery
      graphql_name "FetchStickers"

      argument :page, Integer, required: false
      type [Types::StickerType], null: false
  
      def resolve(page:)
        p = page || 1

        results = Sticker.all.page(p).per(30)

        results
      end
    end
  end