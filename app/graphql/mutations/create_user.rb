module Mutations
    class CreateUser < Mutations::BaseMutation
      argument :params, Types::Input::UserInputType, required: true
  
      field :user, Types::UserType, null: false
  
      def resolve(params:)
        user_params = Hash params
        user_params[:role] = :user
  
        begin
          user = User.new(user_params)
          user.gallery = Gallery.new

          verify_token = (SecureRandom.random_number(9e5) + 1e5).to_i
          user.password = verify_token
          user.save!

          twilio_sid = Rails.application.credentials.twilio_sid
          twilio_token = Rails.application.credentials.twilio_token
          @client = Twilio::REST::Client.new(twilio_sid, twilio_token)
          @client.messages
            .create(
              body: "Your Senpai verification code: #{verify_token}",
              from: '+1 (855) 648-7497',
              to: user.phone
            )

          { user: user }
        rescue ActiveRecord::RecordInvalid => e
          GraphQL::ExecutionError.new("#{e.record.errors.full_messages.join(', ')}")
        end
      end
    end
  end