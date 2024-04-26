namespace :senpai do
  task text_incomplete_profiles: :environment do

  end
end

User.where(is_fake_profile: false).where(country: %w[CAN USA]).each do |u|
  begin
    twilio_sid = Rails.application.credentials.twilio_sid
    twilio_token = Rails.application.credentials.twilio_token
    @client = Twilio::REST::Client.new(twilio_sid, twilio_token)
    @client.messages
           .create(
             body: "We don't mean to be a bother, but we need your help! Please complete this interview, we need your feedback! Link: https://e7pkc384mto.typeform.com/to/ZThxpgWW",
             from: '+1 (718) 307-2924',
             to: u.phone
           )
  rescue Twilio::REST::RestError
    next
  end
end