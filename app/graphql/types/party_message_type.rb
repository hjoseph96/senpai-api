# frozen_string_literal: true

module Types
  class PartyMessageType < Types::BaseObject
    field :id, ID, null: false
    field :sender_id, Integer
    field :content, String
    field :reaction, Integer
    field :party_chat_id, Integer, null: false
    field :sticker_id, Integer
    field :read, Boolean
    field :deleted_at, GraphQL::Types::ISO8601DateTime
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :party_chat, Types::PartyChatType, null: false
    field :sender, [Types::UserType], null: false
    field :attachment, String
    field :sticker, Types::StickerType
    field :recommendation, Types::RecommendationType
    field :attachment_type, String

    def sender
      object.sender
    end

    def attachment
      object.attachment.present? ? cdn_for(object.attachment) : nil
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
