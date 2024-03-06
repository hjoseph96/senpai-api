module Mutations
  class LeaveParty < Mutations::BaseMutation
    argument :user_id, ID, required: true
    argument :party_id, ID, required: true

    field :party, Types::PartyType, null: false

    def resolve(user_id:, party_id:)
      @user = User.find(user_id)

      unless @user.present?
        return GraphQL::ExecutionError.new('User not found')
      end

      @party = Party.find(party_id)
      unless @party.present?
        return GraphQL::ExecutionError.new('Party not found')
      end

      unless @party.member_ids.include?(user_id)
        return GraphQL::ExecutionError.new('User is not a member of this party')
      end

      @party.members = @party.members - [@user]

      if @party.save!
        @party.all_participants.each do |u|
          PushNotification.create!(
            user_id: u.id,
            event_name: 'someone_left_party',
            content: "#{@user.first_name} has left the party for #{@party.event.title}"
          )
        end
      end

      { party: @party }
    end
  end
end