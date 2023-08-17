module Mutations
    class GetDistanceBetweenUsers < Mutations::BaseMutation
      argument :user_id, Integer, required: true
      argument :viewee_id, Integer, required: true
  
      field :mi, Integer, null: false
  
      def resolve(user_id:, viewee_id:)
        @user = User.find(user_id)
        @viewee = User.find(viewee_id)

        user_latlong = Geocoder.search(@user.current_sign_in_ip)[0].data['loc'].split(',')
        viewee_latlong = Geocoder.search(@viewee.current_sign_in_ip)[0].data['loc'].split(',')

        distance = Geocoder::Calculations.distance_between(user_latlong, viewee_latlong, units: :mi)

        { mi: distance }
      end
    end
  end