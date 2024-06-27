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
    field :fetch_characters, resolver: Queries::FetchCharacters
    field :fetch_messages, resolver: Queries::FetchMessages
    field :fetch_stickers, resolver: Queries::FetchStickers
    field :fetch_sticker, resolver: Queries::FetchSticker
    field :fetch_events, resolver: Queries::FetchEvents
    field :fetch_event, resolver: Queries::FetchEvent
    field :fetch_conventions, resolver: Queries::FetchConventions
    field :fetch_convention, resolver: Queries::FetchConvention
    field :fetch_join_requests, resolver: Queries::FetchJoinRequests
    field :fetch_avatars, resolver: Queries::FetchAvatars
    field :fetch_tournaments, resolver: Queries::FetchTournaments

    field :fetch_current_battle, resolver: Queries::Discord::FetchCurrentBattle

    #  admin queries
    field :fetch_reports, resolver: Queries::FetchReports
    field :fetch_verify_requests, resolver: Queries::FetchVerifyRequests
  end
end
