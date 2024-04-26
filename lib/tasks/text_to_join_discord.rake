namespace :senpai do
  task text_incomplete_profiles: :environment do
    User.profile_filled.where(is_fake_profile: false).each do |u|
      begin
        twilio_sid = Rails.application.credentials.twilio_sid
        twilio_token = Rails.application.credentials.twilio_token
        @client = Twilio::REST::Client.new(twilio_sid, twilio_token)

        msg = ''
        if %w(USA CAN).include?(u.country)
          msg = "Enjoy using Senpai? Join us on Discord! \n\n https://discord.gg/f6tctFWz7C"
        elsif u.country == 'BRA'
          msg = "Gostou de usar o Senpai? Junte-se a nós no Discord! \n\n https://discord.gg/f6tctFWz7C"
        else
          next
        end

        @client.messages
               .create(
                 body: msg,
                 from: '+1 (718) 307-2924',
                 to: u.phone
               )
      rescue Twilio::REST::RestError
        next
      end
    end
  end
end