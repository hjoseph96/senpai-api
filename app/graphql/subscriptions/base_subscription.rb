
module Subscriptions
    class BaseSubscription < GraphQL::Schema::Subscription
      def current_application_context
        context[:current_application_context]
      end
    end
end