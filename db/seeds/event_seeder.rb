class EventSeeder
  def self.create_events
    new.create_events
  end

  def create_events
    puts 'Seeding events...'

    @events_path = "#{Rails.root}/db/seeds/event_seeds/"

    go_out_for_drinks
    go_bowling
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
      lonlat: "POINT(-122.142677 37.459775)"
    )

    event.cover_image.attach(blob)

    event.save!
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
      lonlat: "POINT(-122.014012 37.326806)"
    )

    event.cover_image.attach(blob)

    event.save!
  end
end