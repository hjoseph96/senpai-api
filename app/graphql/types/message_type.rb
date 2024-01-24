# frozen_string_literal: true

module Types
  class MessageType < Types::BaseObject
    include ApplicationHelper

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
      object.attachment.present? ? cdn_for(object.attachment) : nil
    end

    def sticker
      dataloader.with(Sources::StickerByMessageId).load(object.id)
    end

    def recommendation
      dataloader.with(Sources::RecommendationByMessageId).load(object.id)
    end

    def attachment_type
      object.attachment.content_type
    end
  end
end
