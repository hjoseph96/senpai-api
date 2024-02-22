# frozen_string_literal: true

module Mutations
  class RemovePartyMember < Mutations::BaseMutation
    graphql_name "RemovePartyMember"

    argument :host_id, ID, required: true
    argument :party_id, ID, required: true
    argument :removed_user_id, ID, required: true

    field :party, Types::PartyType, null: false

    def resolve(host_id:, party_id:, removed_user_id:)
      @host = User.find(host_id)

      unless @host.present?
        return GraphQL::ExecutionError.new("Hosting User not found")
      end

      @party = Party.find(party_id)

      unless @party.host_id == @host.id
        return GraphQL::ExecutionError.new('User is not the host of the party')
      end

      begin
        user_to_remove = User.find(removed_user_id)
        @party.members = @party.members - [user_to_remove]
        @party.save!

        { party: @party.reload }
      rescue ActiveRecord::RecordInvalid => e
        GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}: #{e.record.errors.full_messages.join(', ')}")
      end
    end
  end
end