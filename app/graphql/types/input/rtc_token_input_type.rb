
module Types
  module Input
    class RtcTokenInputType < Types::BaseInputObject
      argument :user_id, ID, required: true
      argument :channel_name, ID, required: true
      argument :is_testing, Boolean, required: false
    end
  end
end