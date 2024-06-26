# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :phone, String, null: false
    field :first_name, String, null: false
    field :birthday, GraphQL::Types::ISO8601DateTime
    field :encrypted_password, String, null: false
    field :sign_in_count, Integer, null: false
    field :current_sign_in_at, GraphQL::Types::ISO8601DateTime
    field :last_sign_in_at, GraphQL::Types::ISO8601DateTime
    field :current_sign_in_ip, String
    field :last_sign_in_ip, String
    field :online_status, String
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :gender, String
    field :desired_gender, String
    field :lonlat, String
    field :bio, String
    field :school, String
    field :occupation, String
    field :premium, Boolean, null: false
    field :verified, Boolean, null: false
    field :role, String, null: false
    field :country, String
    field :display_city, String
    field :display_state, String
    field :super_like_count, Integer
    field :has_location_hidden, Boolean
    field :is_displaying_active, Boolean
    field :is_displaying_recently_active, Boolean
    field :is_fake_profile, Boolean, null: false
    field :next_payment_date, GraphQL::Types::ISO8601DateTime


    field :animes, [Types::AnimeType]
    field :matches, [Types::MatchType]
    field :gallery, Types::GalleryType
    field :favorite_music, [Types::FavoriteMusicType]
    field :blocks, [Types::BlockType]
    field :miles_away, Integer do
      argument :other_user_id, ID
    end
    field :events, [Types::EventType] do
      argument :page, Integer
    end
    field :attending_events, [Types::EventType]
    field :host_reviews, [Types::ReviewType]
    field :host_score, Float
    field :party_member_reviews, [Types::ReviewType]
    field :party_member_score, Float
    field :video_call_score, Float

    field :avatars, [Types::AvatarType]
    field :background_settings, [Types::AvatarType]

    field :device_infos, [Types::DeviceInfoType]

    def animes
      dataloader.with(Sources::AnimesByUserId).load(object.id)
    end

    def matches
      dataloader.with(Sources::MatchesByUserId).load(object.id)
    end

    def gallery
      dataloader.with(Sources::GalleryByUserId).load(object.id)
    end

    def favorite_music
      dataloader.with(Sources::FavoriteMusicsByUserId).load(object.id)
    end

    def blocks
      dataloader.with(Sources::BlocksByUserId).load(object.id)
    end

    def avatars
      object.avatars
    end

    def background_settings
      object.background_settings
    end

    def events(page: 1)
      object.events.page(page)
    end

    def attending_events
      object.attended_parties.map(&:event)
    end

    def miles_away(other_user_id:)
      @other_user = User.find(other_user_id)

      p1 = RGeo::Geographic.spherical_factory.point(object.lonlat.longitude, object.lonlat.latitude)

      p2 = RGeo::Geographic.spherical_factory.point(@other_user.lonlat.longitude, @other_user.lonlat.latitude)

      p1.distance(p2) / 1609.34
    end

    def host_reviews
      object.host_reviews
    end

    def host_score
      object.host_score
    end

    def party_member_reviews
      object.party_member_reviews
    end

    def party_member_score
      object.party_member_score
    end

    def video_call_score
      object.video_call_score
    end

    def device_infos
      object.device_infos
    end
  end
end
