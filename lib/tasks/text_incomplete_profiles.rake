namespace :senpai do
  task text_incomplete_profiles: :environment do
    User.where(first_name: nil).each do |u|
      begin
        twilio_sid = Rails.application.credentials.twilio_sid
        twilio_token = Rails.application.credentials.twilio_token
        @client = Twilio::REST::Client.new(twilio_sid, twilio_token)
        @client.messages
               .create(
                 body: "Didn't complete your profile? Senpai is growing, come back! \n\n https://play.google.com/store/apps/details?id=makeshift.software.inc.senpai",
                 from: '+1 (718) 307-2924',
                 to: u.phone
               )
      rescue Twilio::REST::RestError
        u.destroy_fully!
      end
    end
  end
end