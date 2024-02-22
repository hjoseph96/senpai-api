module Sources
  class MembersByPartyId < GraphQL::Dataloader::Source
    def fetch(party_ids)
      records = {}

      Party.includes(:members).where(id: party_ids).each do |party|
        records[party.id] = party.members
      end

      party_ids.map { |id| records[id] }
    end
  end
end