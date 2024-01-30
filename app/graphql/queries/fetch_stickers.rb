module Queries
    class FetchStickers < Queries::BaseQuery
      graphql_name "FetchStickers"

      argument :page, Integer, required: false
      type [Types::StickerType], null: false
  
      def resolve(page:)
        unless context[:ready?]
          raise GraphQL::ExecutionError.new('Unauthorized Error', options: { status: :unauthorized, code: 401 })
        end

        p = page || 1

        results = Sticker.all.order(created_at: :desc).page(p).per(30)
        
        results
      end
    end
  end