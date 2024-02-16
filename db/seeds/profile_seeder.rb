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

    def nyc_points
        nyc_long_points = (-73.744070..-72.744070).step(0.005).to_a
        nyc_lat_points = (40.720430..41.4332).step(0.005).to_a
        { long: nyc_long_points.sample, lat: nyc_lat_points.sample }
    end

    def atlantic_city_points
        ac_lat_points = (39.362782..39.6).step(0.005).to_a
        ac_long_points = (-74.426904..-74).step(0.005).to_a
        { long: ac_long_points.sample, lat: ac_lat_points.sample }
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

    def mandi_points
        mandi_lat_points = (31.591976..31.60023).step(0.0005).to_a
        mandi_long_points = (76.953942..76.98000).step(0.0005).to_a
        { long: mandi_long_points.sample, lat: mandi_lat_points.sample }
    end

    def palo_alto_points
        palo_alto_lat_points = (37.407263..37.90343).step(0.0005).to_a
        palo_alto_long_points = (-122.124556..-122).step(0.0005).to_a
        { long: palo_alto_long_points.sample, lat: palo_alto_lat_points.sample }
    end

    def chandigarh_points
        chandigarh_lat_points = (30.744648..30.90343).step(0.0005).to_a
        chandigarh_long_points = (76.751141..77.0).step(0.0005).to_a
        { long: chandigarh_long_points.sample, lat: chandigarh_lat_points.sample }
    end

    def tokyo_points
        tokyo_lat_points = (35.674830..36).step(0.0005).to_a
        tokyo_long_points = (139.700447..139.8).step(0.0005).to_a
        { long: tokyo_long_points.sample, lat: tokyo_lat_points.sample }
    end

    def create_females
        puts 'Seeding women...'

        ai_female_gallery_path = "#{Rails.root}/db/seeds/profile_seeds/female"
        Dir.foreach(ai_female_gallery_path) do |filename|
            next if filename == '.' or filename == '..'

            point = nil
            case @location
                when 'NYC' then point = nyc_points
                when 'ATLANTIC CITY' then point = atlantic_city_points
                when 'KIEV' then point = kiev_points
                when 'KAMPALA' then point = kampala_points
                when 'MANDI' then point = mandi_points
                when 'CHANDIGARH' then point = chandigarh_points
                when 'PALO ALTO' then point = palo_alto_points
                when 'TOKYO' then point = tokyo_points
                else
                    throw StandardError("Unsupported seed location.")
            end

            u = User.create(
                phone: Faker::PhoneNumber.cell_phone,
                password: (SecureRandom.random_number(9e5) + 1e5).to_i,
                first_name: Faker::Name.female_first_name,
                role: :user,
                gender: :female,
                desired_gender: :desires_men,
                lonlat: RGeo::Cartesian.factory(:srid => 4326).point(point[:long], point[:lat]),
                birthday: (30.years.ago.to_date..18.years.ago.to_date).to_a.sample,
                bio: generate_bio,
                school: Faker::University.name,
                occupation: Faker::Job.position,
                current_sign_in_ip: '173.52.91.160',
                current_sign_in_at: DateTime.now,
                verified: [true, false].sample,
                is_fake_profile: true
            )
            g = Gallery.create
            u.gallery = g
            u.save!

            set_display_location(u, point)

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
                when 'NYC' then point = nyc_points
                when 'ATLANTIC CITY' then point = atlantic_city_points
                when 'KIEV' then point = kiev_points
                when 'KAMPALA' then point = kampala_points
                when 'MANDI' then point = mandi_points
                when 'CHANDIGARH' then point = chandigarh_points
                when 'PALO ALTO' then point = palo_alto_points
                when 'TOKYO' then point = tokyo_points
            else
                    throw StandardError("Unsupported seed location.")
            end

            u = User.create(
                phone: Faker::PhoneNumber.cell_phone,
                password: (SecureRandom.random_number(9e5) + 1e5).to_i,
                first_name: Faker::Name.male_first_name,
                role: :user,
                gender: :male,
                desired_gender: :desires_women,
                bio: generate_bio,
                birthday: (30.years.ago.to_date..18.years.ago.to_date).to_a.sample,
                school: Faker::University.name,
                occupation: Faker::Job.position,
                lonlat: RGeo::Cartesian.factory(srid: 4326).point(point[:long], point[:lat]),
                current_sign_in_ip: '173.52.91.160',
                current_sign_in_at: DateTime.now,
                verified: [true, false].sample,
                is_fake_profile: true
            )

            set_display_location(u, point)

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

    def set_display_location(user, point)
        location =  Geocoder.search("#{point[:lat]}, #{point[:long]}")[0]
        state = location.city == location.state ? location.country : location.state

        user.update!(
          display_city: location.city,
          display_state: state,
          country: location.country
        )
    end

    def generate_bio
        [
          Faker::Quote.mitch_hedberg,
          Faker::Quote.jack_handey,
          Faker::Quote.famous_last_words,
          Faker::Quote.robin
        ].sample
    end

end