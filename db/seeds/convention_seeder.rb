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
      lonlat: "POINT(-84.402063 33.759965)"
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
      lonlat: "POINT(-97.738789 30.264003)"
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
      lonlat: "POINT(-74.002040 40.757355)"
    )

    anime_nyc.cover_image.attach(blob)

    anime_nyc.save!
  end
end