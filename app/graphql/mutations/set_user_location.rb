module Mutations
    class SetUserLocation < Mutations::BaseMutation
      argument :longitude, String, required: true
      argument :latitude, String, required: true
  
      field :user, Types::UserType, null: false
  
      def resolve(user_id:, latitude:, longitude:)
        unless context[:ready?]
          raise GraphQL::ExecutionError.new('Unauthorized Error', options: { status: :unauthorized, code: 401 })
        end

        @user = context[:current_user]

        location =  Geocoder.search("#{latitude}, #{longitude}")[0]
        point = "POINT(#{longitude} #{latitude})"
        state = location.city == location.state ? location.country : location.state
        updated = @user.update(
            display_city: location.city,
            display_state: state,
            lonlat: point
        )
        
        if updated
            { user: @user }
        else
            GraphQL::ExecutionError.new("Update failed: #{@user.errors.join(', ')}")
        end
      end
    end
  end