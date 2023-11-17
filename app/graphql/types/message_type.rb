# frozen_string_literal: true

module Types
  class MessageType < Types::BaseObject
    field :id, ID, null: false
    field :sender_id, Integer
    field :content, String
    field :conversation_id, String
    field :reaction, String
    field :read, Boolean
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :attachment, String
    field :sticker, Types::StickerType
    field :recommendation, Types::RecommendationType
    field :attachment_type, String

    def attachment
      cdn_for(object.attachment)
    end

    def sticker
      object.sticker
    end

    def recommendation
      object.recommendation
    end

    def attachment_type
      object.attachment.content_type
    end
  end
end
