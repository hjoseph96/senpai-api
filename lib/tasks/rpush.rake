namespace :rpush do
  desc "Create Rpush android app"
  task android_app: [:environment] do
    Rpush::Gcm::App.create(name: "android_app", connections: 1, environment: Rails.env, type: "Rpush::Client::ActiveRecord::Gcm::App", auth_key: Rails.application.credentials.fcm_server_key)
    puts "Rpush Android app created Successfully"
  end

  desc "Create Rpush Ios app"
  task ios_app: [:environment] do
    Rpush::Gcm::App.create(name: "ios_app", connections: 1, environment: Rails.env, type: "Rpush::Client::ActiveRecord::Gcm::App", auth_key: Rails.application.credentials.fcm_server_key, certificate: File.read("config/AuthKey_UQ242H8R76.p8"))
    puts "Rpush IOS app created Successfully"
  end
end
