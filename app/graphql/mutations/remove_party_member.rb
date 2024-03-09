# frozen_string_literal: true

module Mutations
  class RemovePartyMember < Mutations::BaseMutation
    graphql_name "RemovePartyMember"

    argument :party_id, ID, required: true
    argument :removed_user_id, ID, required: true

    field :party, Types::PartyType, null: false

    def resolve(party_id:, removed_user_id:)
      @party = Party.find(party_id)

      begin
        user_to_remove = User.find(removed_user_id)
        @party.members = @party.members - [user_to_remove]
        @party.save!

        @party.open! if @party.members.count < @party.member_limit

        PushNotification.create!(
          user_id: user_to_remove.id,
          event_name: 'kicked_from_party',
          content: "You have been kicked from #{@party.event.title}'s party.'"
        )

        { party: @party.reload }
      rescue ActiveRecord::RecordInvalid => e
        GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}: #{e.record.errors.full_messages.join(', ')}")
      end
    end
  end
end