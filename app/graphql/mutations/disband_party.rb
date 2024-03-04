module Mutations
  class DisbandParty < Mutations::BaseMutation
    argument :event_id, ID, required: true

    field :party, Types::GalleryType

    def resolve(party_id:)
      party = Party.find(party_id)

      party.update!(disbanded: true)

      has_members = @party.members.count > 0
      if party.event.is_running? && has_members
        # Only notify party members that party is disbanded

        party.members.each do |member|
          PushNotification.create!(
            user_id: member.id,
            event_name: 'party_disbanded',
            content: "#{@party.host.first_name} has disbanded the party for #{@party.event.title}."
          )
        end
      end

      { party: party }
    end
  end
end
