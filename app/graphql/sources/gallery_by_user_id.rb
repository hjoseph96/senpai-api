module Sources
  class GalleryByUserId < GraphQL::Dataloader::Source
    def fetch(user_ids)
      records = {}

      Gallery.where(user_id: user_ids).group_by(&:user_id).each do |user_id, galleries|
        records[user_id] = galleries.first
      end

      user_ids.map { |id| records[id] }
    end
  end
end