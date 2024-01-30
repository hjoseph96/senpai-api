module Mutations
    class GetDistanceBetweenUsers < Mutations::BaseMutation
      argument :viewee_id, Integer, required: true
  
      field :mi, Integer, null: false
  
      def resolve(viewee_id:)
        unless context[:ready?]
          raise GraphQL::ExecutionError.new('Unauthorized Error', options: { status: :unauthorized, code: 401 })
        end

        @user = context[:current_user]
        @viewee = User.find(viewee_id)

        p1 = RGeo::Geographic.spherical_factory.point(@user.lonlat.longitude, @user.lonlat.latitude)
        p2 = RGeo::Geographic.spherical_factory.point(@viewee.lonlat.longitude, @viewee.lonlat.latitude)

        distance = p1.distance(p2) / 1609.34

        distance = 1 if distance == 0

        { mi: distance }
      end
    end
  end