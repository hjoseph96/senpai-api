module Mutations
    class SetUserLocation < Mutations::BaseMutation
      argument :user_id, Integer, required: true
      argument :longitude, String, required: true
      argument :latitude, String, required: true
  
      field :user, Types::UserType, null: false
  
      def resolve(user_id:, latitude:, longitude:)
        @user = User.find(user_id)
        
        location =  Geocoder.search("#{latitude}, #{longitude}")[0]
        point = "POINT(#{location.longitude} #{location.latitude})"
        state = location.city == location.state ? location.country : location.state

        place = location.instance_values['place']
        city = location.city || place.sub_municipality || place.region

        updated = @user.update(
            country: location.country,
            display_city: city,
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