module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :fetch_anime, resolver: Queries::FetchAnime
    field :fetch_feed, resolver: Queries::FetchFeed
    field :fetch_conversations, resolver: Queries::FetchConversations
    field :fetch_user, resolver: Queries::FetchUser
    field :fetch_messages, resolver: Queries::FetchMessages
    field :fetch_stickers, resolver: Queries::FetchStickers
    field :fetch_sticker, resolver: Queries::FetchSticker

    #  admin queries
    field :fetch_reports, resolver: Queries::FetchReports
    field :fetch_verify_requests, resolver: Queries::FetchVerifyRequests
  end
end
