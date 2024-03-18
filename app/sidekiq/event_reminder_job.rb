class EventReminderJob
  include Sidekiq::Job

  def perform
    events = Event.where('start_date BETWEEN ? AND ?', Time.zone.now, 1.hour.from_now)

    return if events.empty?
    
    events.find_in_batches do |group|
      group.each do |e|
        e.party.all_participants.each do |u|
          PushNotification.create!(
            user_id: u.id,
            event_name: 'event_reminder',
            content: "Event: ''#{e.title}' is starting soon!"
          )
        end
      end
    end
  end
end