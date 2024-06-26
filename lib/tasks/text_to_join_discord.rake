namespace :senpai do
  task text_incomplete_profiles: :environment do
    User.profile_filled.where(is_fake_profile: false).each do |u|
      begin
        twilio_sid = Rails.application.credentials.twilio_sid
        twilio_token = Rails.application.credentials.twilio_token
        @client = Twilio::REST::Client.new(twilio_sid, twilio_token)

        msg = ''
        if %w(USA CAN).include?(u.country)
          msg = "We're done with swiping. \n\n We need your input on our newest feature! Please take this short survey: https://rb.gy/f9c7la"
        elsif u.country == 'BRA'
          msg = "Terminamos de deslizar. \n\n Precisamos da sua opinião sobre nosso mais novo recurso! Por favor, responda a esta breve pesquisa: https://rb.gy/pe97zj"
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