# frozen_string_literal: true

module Types
  class MessageType < Types::BaseObject
    field :id, ID, null: false
    field :sender_id, Integer
    field :content, String
    field :conversation_id, String
    field :reaction, Integer
    field :read, Boolean
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :attachment, String
    field :sticker, Types::StickerType
    field :recommendation, Types::RecommendationType

    def attachment
      cdn_for(object.attachment)
    end

    def sticker
      object.sticker
    end

    def recommendation
      object.recommendation
    end
  end
end
