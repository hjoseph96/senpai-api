class NotificationChannel < ApplicationCable::Channel
  def subscribed
    puts "====================================="
    puts "NOTIFICATIONS FOR #{current_user.id}"
    puts '====================================='
    
    stream_from "Notification-#{current_user.id}"
  end

  def unsubscribed
  end
end