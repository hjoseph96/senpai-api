# frozen_string_literal: true

module Types
  class PhotoType < Types::BaseObject
    include ApplicationHelper
    
    field :id, ID, null: false
    field :gallery_id, ID, null: false
    field :order, Integer
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    field :url, String, null: false

    def url
      cdn_for(object.image)
    end
  end
end
