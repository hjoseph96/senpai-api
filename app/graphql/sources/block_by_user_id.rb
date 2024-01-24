module Sources
  class BlockByUserId < GraphQL::Dataloader::Source
    def fetch(user_ids)
      records = {}

      Block.where(user_id: user_ids).group_by(&:user_id).each do |user_id, blocks|
        records[user_id] = blocks
      end

      user_ids.map { |id| records[id] }
    end
  end
end