module Sources
  class GalleryByUserId < GraphQL::Dataloader::Source
    def fetch(user_ids)
      records = {}

      User.includes(:gallery).where(id: user_ids).each do |user|
        records[user.id] = user.gallery
      end

      user_ids.map { |id| records[id] }
    end
  end
end