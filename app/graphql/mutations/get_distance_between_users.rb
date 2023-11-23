module Mutations
    class GetDistanceBetweenUsers < Mutations::BaseMutation
      argument :user_id, Integer, required: true
      argument :viewee_id, Integer, required: true
  
      field :mi, Integer, null: false
  
      def resolve(user_id:, viewee_id:)
        @user = User.find(user_id)
        @viewee = User.find(viewee_id)

        p1 = RGeo::Geographic.spherical_factory.point(@user.lonlat.longitude, @user.lonlat.latitude)
        p2 = RGeo::Geographic.spherical_factory.point(@viewee.lonlat.longitude, @viewee.lonlat.latitude)

        distance = p1.distance(p2) / 1609.34

        { mi: distance }
      end
    end
  end