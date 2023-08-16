require 'faker'

class ProfileSeeder
    def self.create_profiles
        new.create_profiles
    end

    def create_profiles
        Faker::Config.locale = 'en-US'

        create_females
        create_males
    end

    def create_females
        puts 'Seeding women...'

        ai_female_gallery_path = "#{Rails.root}/db/seeds/profile_seeds/female"
        Dir.foreach(ai_female_gallery_path) do |filename|
            next if filename == '.' or filename == '..'

            u = User.create(
                phone: Faker::PhoneNumber.cell_phone,
                password: (SecureRandom.random_number(9e5) + 1e5).to_i,
                first_name: Faker::Name.female_first_name,
                role: :user,
                gender: :female,
                desired_gender: :desires_men,
                bio: Faker::Lorem.paragraphs,
                school: Faker::University.name,
                occupation: Faker::Job.position,
                current_sign_in_ip: '173.52.91.160',
                current_sign_in_at: DateTime.now
            )

            g = Gallery.create
            u.gallery = g
            u.save!

            photo = File.open("#{ai_female_gallery_path}/#{filename}")
            blob = ActiveStorage::Blob.create_and_upload!(
                io: photo,
                filename: filename
            )
            photo = Photo.new(order: 1)
            photo.image.attach(blob)
            u.gallery.photos << photo

            u.save!

            add_popular_anime(u)
        end
    end

    def create_males
        puts 'Seeding men...'

        ai_male_gallery_path = "#{Rails.root}/db/seeds/profile_seeds/male"
        Dir.foreach(ai_male_gallery_path) do |filename|
            next if filename == '.' or filename == '..'

            u = User.create(
                phone: Faker::PhoneNumber.cell_phone,
                password: (SecureRandom.random_number(9e5) + 1e5).to_i,
                first_name: Faker::Name.male_first_name,
                role: :user,
                gender: :male,
                desired_gender: :desires_women,
                bio: Faker::Lorem.paragraphs,
                school: Faker::University.name,
                occupation: Faker::Job.position,
                current_sign_in_ip: '173.52.91.160',
                current_sign_in_at: DateTime.now
            )

            g = Gallery.create
            u.gallery = g
            u.save!    
            
            photo = File.open("#{ai_male_gallery_path}/#{filename}")
            blob = ActiveStorage::Blob.create_and_upload!(
                io: photo,
                filename: filename
            )
            photo = Photo.new(order: 1)
            photo.image.attach(blob)
            u.gallery.photos << photo

            u.save!

            add_popular_anime(u)
        end
    end

    def add_popular_anime(user)
        chosen_anime = []

        anime = Anime.order(popularity: :asc).reverse_order.limit(100).reverse

        10.times do
            random_anime = anime.sample

            chosen_anime << random_anime unless chosen_anime.include? random_anime
        end

        user.animes = chosen_anime
        user.save!
    end

end