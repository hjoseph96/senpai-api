module Sources
  class StickerByMessageId < GraphQL::Dataloader::Source
    def fetch(message_ids)
      records = {}

      Message.includes(:sticker).where(id: message_ids).each do |message|
        records[message.id] = message.sticker
      end

      message_ids.map { |id| records[id] }
    end
  end
end