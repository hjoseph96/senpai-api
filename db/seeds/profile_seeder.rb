require 'faker'

class ProfileSeeder
    def self.create_profiles(location:)
        new.create_profiles(location: location)
    end

    def create_profiles(location:)
        Faker::Config.locale = 'en-US'

        @location = location

        create_females
        create_males
    end

    def nyc_point
        nyc_long_points = (-73.744070..-72.744070).step(0.005).to_a
        nyc_lat_points = (40.720430..41.4332).step(0.005).to_a
        { long: nyc_long_points.sample, lat: nyc_lat_points.sample }
    end

    def kiev_points
        kiev_long_points = (30.480461..30.485461).step(0.0005).to_a
        kiev_lat_points = (50.458433..50.474027).step(0.0005).to_a
        { long: kiev_long_points.sample, lat: kiev_lat_points.sample }
    end

    def kampala_points
        kampala_long_points = (32.594288..32.994288).step(0.0005).to_a
        kampala_lat_points = (0.293116..0.295).step(0.0005).to_a
        { long: kampala_long_points.sample, lat: kampala_lat_points.sample }
    end


    def create_females
        puts 'Seeding women...'

        ai_female_gallery_path = "#{Rails.root}/db/seeds/profile_seeds/female"
        Dir.foreach(ai_female_gallery_path) do |filename|
            next if filename == '.' or filename == '..'

            point = nil
            case @location
            when 'NYC' then point = nyc_point
            when 'KIEV' then point = kiev_points
            when 'KAMPALA' then point = kampala_points
            end

            u = User.create(
                phone: Faker::PhoneNumber.cell_phone,
                password: (SecureRandom.random_number(9e5) + 1e5).to_i,
                first_name: Faker::Name.female_first_name,
                role: :user,
                gender: :female,
                desired_gender: :desires_men,
                lonlat: RGeo::Cartesian.factory(:srid => 4326).point(point[:long], point[:lat]),
                birthday: (50.years.ago.to_date..18.years.ago.to_date).to_a.sample,
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

            point = nil
            case @location
            when 'NYC' then point = nyc_point
            when 'KIEV' then point = kiev_points
            when 'KAMPALA' then point = kampala_points
            end

            u = User.create(
                phone: Faker::PhoneNumber.cell_phone,
                password: (SecureRandom.random_number(9e5) + 1e5).to_i,
                first_name: Faker::Name.male_first_name,
                role: :user,
                gender: :male,
                desired_gender: :desires_women,
                bio: Faker::Lorem.paragraphs,
                birthday: (50.years.ago.to_date..18.years.ago.to_date).to_a.sample,
                school: Faker::University.name,
                occupation: Faker::Job.position,
                lonlat: RGeo::Cartesian.factory(srid: 4326).point(point[:long], point[:lat]),
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