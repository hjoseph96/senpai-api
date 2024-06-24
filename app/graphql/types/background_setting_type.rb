# frozen_string_literal: true

module Types
  class BackgroundSettingType < Types::BaseObject
    field :id, ID, null: false
    field :title, String
    field :sky_color, String
    field :equator_color, String
    field :ground_color, String
    field :enable_stars, Boolean
    field :enable_clouds, Boolean
    field :user_id, Integer, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
