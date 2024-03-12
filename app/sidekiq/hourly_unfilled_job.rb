class HourlyUnfilledJob
  include Sidekiq::Job

  def perform
    unfinished_profiles = User.profile_unfilled

    unfinished_profiles.find_in_batches do |group|
      group.each do |u|
        if u.updated_at < 1.hour.from_now
          PushNotification.create!(
            user_id: u,
            event_name: 'profile_unfilled',
            content: 'Did you forget to fill your profile?'
          )
        end
      end
    end
  end
end