module Sources
  class PartyMessagesByPartyChat < GraphQL::Dataloader::Source
    def fetch(party_chat_ids)
      records = {}

      PartyChat.includes(:messages).where(id: party_chat_ids).each do |chat|
        records[chat.id] = chat.messages
      end

      party_chat_ids.map { |id| records[id] }
    end
  end
end