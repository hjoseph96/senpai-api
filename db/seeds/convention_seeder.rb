class ConventionSeeder
  def self.create_conventions
    new.create_conventions
  end

  def create_conventions
    puts 'Seeding conventions...'

    @covers_path = "#{Rails.root}/db/seeds/convention_seeds/"

    create_momocon
    create_dreamcon
    create_anime_nyc
  end

  def create_momocon
    filename = "mmc-home-hero.jpg"

    photo = File.open("#{@covers_path}/#{filename}")

    blob = ActiveStorage::Blob.create_and_upload!(
      io: photo,
      filename: filename
    )

    momocon = Convention.create!(
      title: 'MomoCon',
      venue: 'Georgia World Congress Center',
      country: 'US',
      display_city: 'Atlanta',
      display_state: 'GA',
      start_date: Date.parse('May 24, 2024'),
      end_date: Date.parse('May 27, 2024'),
      website: 'https://www.momocon.com/',
      lonlat: "POINT(-84.402063 33.759965)",
      full_address: '285 Andrew Young International Blvd NW Atlanta, GA 30303',
      description: "MomoCon brings together fans of Japanese Anime, American Animation, Comics, Video Games, and Tabletop Games to celebrate their passion by costuming / cosplay, browsing the huge exhibitors hall, meeting celebrity voice talent, designers, and writers behind their favorite shows, games, and comics and much much more over this 4 day event."
    )

    momocon.cover_image.attach(blob)

    momocon.save!
  end

  def create_dreamcon
    filename = 'dreamcon.png'

    photo = File.open("#{@covers_path}/#{filename}")

    blob = ActiveStorage::Blob.create_and_upload!(
      io: photo,
      filename: filename
    )

    dreamcon = Convention.create!(
      title: 'Dream Con',
      venue: 'Austin Convention Center',
      country: 'US',
      display_city: 'Austin',
      display_state: 'TX',
      start_date: Date.parse('July 26, 2024'),
      end_date: Date.parse('July 28, 2024'),
      website: 'https://www.dreamconvention.com/',
      lonlat: "POINT(-97.738789 30.264003)",
      full_address: '500 E. Cesar Chavez St. Austin, TX 78701',
      description: "Dream Con is an anime and gaming convention that started as a dream but was brought to fruition by social media influencers, RDCWorld. RDCWorld dreamed of bringing together like-minded individuals to enjoy and celebrate multiple interests including pop culture, comics, art, cosplay, music and much more. As of 2023, Dream Con will take place in Austin, TX.

At Dream Con, it doesn’t matter if you are a novice or an avid fan, this is a place where you will be accepted as you are! With guests ranging from notable voice actors to popular content creators, you never know who you might Naruto run into.

Dream Con provides endless entertainment for you all weekend long, with a traditional artist alley, engaging panels, memorable meet & greets, and invigorating concerts. Dream Con also has staple events such as: All-Star Super Smash Bros Tournament, Crew Battle, Dodgeball, and Cosplay Contest and Runway."
    )

    dreamcon.cover_image.attach(blob)

    dreamcon.save!
  end

  def create_anime_nyc
    filename = 'anime_nyc.png'

    photo = File.open("#{@covers_path}/#{filename}")

    blob = ActiveStorage::Blob.create_and_upload!(
      io: photo,
      filename: filename
    )

    anime_nyc = Convention.create!(
      title: 'Anime NYC',
      venue: 'Javits Convention Center',
      country: 'US',
      display_city: 'New York',
      display_state: 'NY',
      start_date: Date.parse('August 23, 2024'),
      end_date: Date.parse('August 25, 2024'),
      website: 'https://animenyc.com/',
      lonlat: "POINT(-74.002040 40.757355)",
      full_address: '445 11th Ave, New York, NY 10001',
      description: "Anime NYC is New York City’s anime convention! A showcase of the best of Japanese pop culture in the biggest city in America, Anime NYC brings anime fans together for three days of unique exhibits, exclusive screenings, and appearances by some of the biggest creators in Japan!"
    )

    anime_nyc.cover_image.attach(blob)

    anime_nyc.save!
  end
end