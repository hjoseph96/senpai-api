class EventSeeder
  def self.create_events
    new.create_events
  end

  def create_events
    puts 'Seeding events...'

    @events_path = "#{Rails.root}/db/seeds/event_seeds/"

    go_out_for_drinks
    go_bowling
    archery_practice
    swordsman_training
    dinner_at_gramercy
    momocon_party
    dreamcon_party
  end

  def go_out_for_drinks
    filename = "bar.jpg"

    photo = File.open("#{@events_path}/#{filename}")

    blob = ActiveStorage::Blob.create_and_upload!(
      io: photo,
      filename: filename
    )

    event = Event.create!(
      title: 'Night out for Drinks!',
      venue: 'Quattro Restaurant & Bar',
      host_id: User.all.sample.id,
      cosplay_required: :no,
      payment_required: false,
      country: 'US',
      display_city: 'Palo Alto',
      display_state: 'CA',
      start_date: Date.parse('June 24, 2024'),
      description: "Let's have a fun night out!",
      lonlat: "POINT(-122.142677 37.459775)",
      full_address: '2050 University Ave, East Palo Alto, CA 94303'
    )

    event.cover_image.attach(blob)

    event.save!

    p = Party.create!(
      event_id: event.id,
      host_id: event.host_id,
      member_limit: 10
    )

    seed_party_members(p)
  end

  def go_bowling
    filename = "bowling.jpeg"

    photo = File.open("#{@events_path}/#{filename}")

    blob = ActiveStorage::Blob.create_and_upload!(
      io: photo,
      filename: filename
    )

    event = Event.create!(
      title: 'Strikeout Night',
      venue: 'Bowlmor Cupertino',
      host_id: User.all.sample.id,
      cosplay_required: :no,
      payment_required: false,
      country: 'US',
      display_city: 'Palo Alto',
      display_state: 'CA',
      start_date: Date.parse('April 24, 2024'),
      description: "Hit strikes all night!",
      lonlat: "POINT(-122.014012 37.326806)",
      full_address: '10123 N Wolfe Rd Ste 20 Cupertino, CA 95014'
    )

    event.cover_image.attach(blob)

    event.save!

    p = Party.create!(
      event_id: event.id,
      host_id: event.host_id,
      member_limit: 10
    )

    seed_party_members(p)
  end

  def archery_practice
    filename = "archery.jpeg"

    photo = File.open("#{@events_path}/#{filename}")

    blob = ActiveStorage::Blob.create_and_upload!(
      io: photo,
      filename: filename
    )

    event = Event.create!(
      title: 'Archery Training',
      venue: 'Gotham Archery',
      host_id: User.all.sample.id,
      cosplay_required: :no,
      payment_required: true,
      country: 'US',
      display_city: 'New York',
      display_state: 'NY',
      start_date: Date.parse('May 24, 2024'),
      description: "Shoot a bullseye! Let's get some target practice in.",
      lonlat: "POINT(-73.99146861577013 40.71769471623873)",
      full_address: '73 Allen St, New York, NY 10002'
    )

    event.cover_image.attach(blob)

    event.save!

    p = Party.create!(
      event_id: event.id,
      host_id: event.host_id,
      member_limit: 10
    )

    seed_party_members(p)
  end

  def swordsman_training
    filename = "kendo.jpeg"

    photo = File.open("#{@events_path}/#{filename}")

    blob = ActiveStorage::Blob.create_and_upload!(
      io: photo,
      filename: filename
    )

    event = Event.create!(
      title: 'Fun with Kendo!',
      venue: 'Gotham Archery',
      host_id: User.all.sample.id,
      cosplay_required: :no,
      payment_required: true,
      country: 'US',
      display_city: 'New York',
      display_state: 'NY',
      start_date: Date.parse('August 24, 2024'),
      description: "Join the quest to become the finest swordsman!",
      lonlat: "POINT(-73.94091531344117 40.80559806877782)",
      full_address: '1944 Madison Ave, New York, NY 10035'
    )

    event.cover_image.attach(blob)

    event.save!

    p = Party.create!(
      event_id: event.id,
      host_id: event.host_id,
      member_limit: 10
    )

    seed_party_members(p)
  end

  def dinner_at_gramercy
    filename = "gramercy.jpeg"

    photo = File.open("#{@events_path}/#{filename}")

    blob = ActiveStorage::Blob.create_and_upload!(
      io: photo,
      filename: filename
    )

    event = Event.create!(
      title: 'Dinner @ Gramercy Tavern',
      venue: 'Gramercy Tavern',
      host_id: User.all.sample.id,
      cosplay_required: :no,
      payment_required: true,
      country: 'US',
      display_city: 'New York',
      display_state: 'NY',
      start_date: Date.parse('September 24, 2024'),
      description: 'Enjoy fine dining over @ the Gramercy Tavern',
      lonlat: "POINT(-73.98843131581225 40.73851230200502)",
      full_address: '42 E 20th St, New York, NY 10003'
    )

    event.cover_image.attach(blob)

    event.save!

    p = Party.create!(
      event_id: event.id,
      host_id: event.host_id,
      member_limit: 10
    )

    seed_party_members(p)
  end

  def momocon_party
    filename = "dbz_group.jpeg"

    photo = File.open("#{@events_path}/#{filename}")

    blob = ActiveStorage::Blob.create_and_upload!(
      io: photo,
      filename: filename
    )

    event = Event.create!(
      title: 'DBZ Group Cosplay Party',
      venue: 'Javits Convention Center',
      host_id: User.all.sample.id,
      cosplay_required: :required,
      payment_required: true,
      country: 'US',
      display_city: 'New York',
      display_state: 'NY',
      start_date: Date.parse('September 24, 2024'),
      description: "Let's praise Toriyama with a group DBZ cosplay!",
      lonlat: "POINT(-74.002040 40.757355)",
      full_address: '445 11th Ave, New York, NY 10001',
      convention_id: Convention.find_by(title: 'Anime NYC').id
    )

    event.cover_image.attach(blob)

    event.save!

    p = Party.create!(
      event_id: event.id,
      host_id: event.host_id,
      member_limit: 10
    )

    seed_party_members(p)
  end

  def dreamcon_party
    filename = "group_naruto_cosplay.jpeg"

    photo = File.open("#{@events_path}/#{filename}")

    blob = ActiveStorage::Blob.create_and_upload!(
      io: photo,
      filename: filename
    )

    event = Event.create!(
      title: 'Naruto Cosplay Party',
      venue: 'Austin Convention Center',
      host_id: User.all.sample.id,
      cosplay_required: :required,
      payment_required: true,
      country: 'US',
      display_city: 'Austin',
      display_state: 'TX',
      start_date: Date.parse('July 26, 2024'),
      description: "Let's praise Kishimoto with a group HxH cosplay!",
      lonlat: "POINT(-97.738789 30.264003)",
      full_address: '500 E. Cesar Chavez St. Austin, TX 78701',
      convention_id: Convention.find_by(title: 'Dream Con').id
    )

    event.cover_image.attach(blob)

    event.save!

    p = Party.create!(
      event_id: event.id,
      host_id: event.host_id,
      member_limit: 10
    )

    seed_party_members(p)
  end

  def seed_party_members(party)
    user_pool = User.pluck(:id).shuffle[0..[*3..9].sample]

    user_pool.each do |id|
      UserParty.create!(user_id: id, party_id: party.id)
    end
  end
end