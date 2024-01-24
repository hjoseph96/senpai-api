module Sources
  class PhotosByGalleryId < GraphQL::Dataloader::Source
    def fetch(gallery_ids)
      records = {}

      Gallery.includes(:photos).where(id: gallery_ids).each do |gallery|
        records[gallery.id] = gallery.photos.order(order: :asc)
      end

      gallery_ids.map { |id| records[id] }
    end
  end
end