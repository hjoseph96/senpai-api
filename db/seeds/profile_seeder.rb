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
                occupation: Faker::Job.position
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
        end

        def create_males
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
                    occupation: Faker::Job.position
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
            end
        end
    end
end