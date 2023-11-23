require 'faker'

class ProfileSeeder
    def self.create_profiles(location:)
        new.create_profiles(location: location)
    end

    def create_profiles(location:)
        Faker::Config.locale = 'en-US'

        case location
        when 'NYC' then @location = "POINT(#{-73.744070} #{40.720430})"
        when 'KIEV' then @location = "POINT(#{30.5071277} #{50.4571249})"
        when 'KAMPALA' then @location = "POINT(#{32.603056} #{0.284559})"
        end

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
                lonlat: @location,
                birthday: (50.years.ago.to_date..16.years.ago.to_date).to_a.sample,
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
                birthday: (50.years.ago.to_date..16.years.ago.to_date).to_a.sample,
                school: Faker::University.name,
                occupation: Faker::Job.position,
                lonlat: @location,
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