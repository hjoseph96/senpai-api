
module Subscriptions
    class MessageReply < BaseSubscription
      field :message, Types::MessageType, null: false
    end
end