# frozen_string_literal: true

module Types
  class ReportType < Types::BaseObject
    field :id, ID, null: false
    field :user_id, Integer, null: false
    field :offense_id, Integer
    field :reason, String
    field :conversation_id, ID, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :reporter, Types::UserType, null: false
    field :offender, Types::UserType, null: false
    field :conversation, Types::ConversationType, null: false

    def reporter
      dataloader.with(Sources::UserByReportId).load(object.id)
    end

    def offender
      dataloader.with(Sources::OffenderByReportId).load(object.id)
    end

    def conversation
      dataloader.with(Sources::ConversationByReportId).load(object.id)
    end
  end
end
