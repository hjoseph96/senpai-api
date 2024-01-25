module Sources
  class BlocksByUserId < GraphQL::Dataloader::Source
    def fetch(user_ids)
      records = {}

      User.includes(:blocks).where(id: user_ids).each do |user|
        records[user.id] = user.blocks
      end

      user_ids.map { |id| records[id] }
    end
  end
end