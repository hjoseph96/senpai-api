class ConventionReminderJob
  include Sidekiq::Job

  def perform
    conventions = Convention.where('start_date BETWEEN ? AND ?', Time.zone.now, 1.hour.from_now)

    return if conventions.empty?

    conventions.find_in_batches do |group|
      group.each do |c|
        c.attendees.each do |u|
          PushNotification.create!(
            user_id: u.id,
            event_name: 'convention_reminder',
            content: "Convention: ''#{c.title}' is starting soon!"
          )
        end
      end
    end
  end
end