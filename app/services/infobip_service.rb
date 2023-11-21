# frozen_string_literal: true

require 'faraday'

class InfobipService
  def initialize
    api_key = Rails.application.credentials.infobip_api_key
    @client = Faraday.new(
      url: 'https://e1d8d3.api.infobip.com/',
      headers: { 'Authorization' => "App #{api_key}" }
    )
  end

  def self.send_sms_verify_code(outbound_number, code)
    new.send_sms_verify_code(outbound_number, code)
  end

  def send_sms_verify_code(outbound_number, code)
    response = @client.post('sms/2/text/advanced') do |req|
      req.headers['Content-Type'] = 'application/json'
      req.body = {
        messages: [{
                     'destinations': [{ 'to': outbound_number }],
                     'from': 'Senpai',
                     'text': "Your Senpai verification code: #{code}"
                   }]
      }.to_json
    end
    binding.pry

  end


end
