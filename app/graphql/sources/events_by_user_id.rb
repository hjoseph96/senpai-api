module Sources
  class EventsByUserId < GraphQL::Dataloader::Source
    def fetch(user_ids)
      records = {}

      User.includes(:events).where(id: user_ids).each do |user|
        records[user.id] = user.events
      end

      user_ids.map { |id| records[id] }
    end
  end
end