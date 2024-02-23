module Mutations
  class LeaveReview < Mutations::BaseMutation
    argument :params, Types::Input::ReviewInputType, required: true

    field :event, Types::EventType, null: false

    def resolve(params:)
      review_params = Hash params

      @user = User.find(review_params[:user_id])

      accepted_classes = %w(User Convention Event)
      class_name = review_params[:reviewable_type]
      unless accepted_classes.include?(class_name)
        return GraphQL::ExecutionError.new('Given invalid class name')
      end

      class_id = review_params[:reviewable_id]
      @reviewee = class_name.constantize.find(class_id)

      @review = Review.create!(review_params)

      case class_name
        when 'User'
          if @review.review_type == :party_member
            PushNotification.create!(
              user_id: @reviewee.id,
              event_name: 'new_party_member_review',
              content: "#{@user.first_name} left you a review!"
            )
          elsif @review.review_type == :host
            PushNotification.create!(
              user_id: @reviewee.id,
              event_name: 'new_host_review',
              content: "#{@user.first_name} left a new review on an event you hosted!"
            )
          end
        when 'Event'
          PushNotification.create!(
            user_id: @reviewee.host.id,
            event_name: 'new_event_review',
            content: "#{@user.first_name} has left you a review!"
          )
        end
    end
  end
end