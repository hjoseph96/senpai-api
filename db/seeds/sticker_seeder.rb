class StickerSeeder
    def self.create_stickers
        new.create_stickers
    end

    def create_stickers
        puts 'Seeding stickers...'

        stickers_path = "#{Rails.root}/db/seeds/sticker_seeds"

        Dir.foreach(stickers_path) do |filename|
            next if filename == '.' or filename == '..'

            photo = File.open("#{stickers_path}/#{filename}")
            blob = ActiveStorage::Blob.create_and_upload!(
                io: photo,
                filename: filename
            )
            sticker = Sticker.new
            sticker.image.attach(blob)
            sticker.save!
        end
    end
end