module Mutations
    class CreateUser < Mutations::BaseMutation
      argument :params, Types::Input::UserInputType, required: true
  
      field :user, Types::UserType, null: false
      field :token, String, null: false
  
      def resolve(params:)
        user_params = Hash params
  
        begin
          user = User.create!(user_params)
          user.gallery = Gallery.new

          verify_token = (SecureRandom.random_number(9e5) + 1e5).to_i
          user.password = token
          user.save

          twilio_sid = Rails.application.credentials.twilio_sid
          twilio_token = Rails.application.credentials.twilio_token
          @client = Twilio::REST::Client.new(twilio_sid, twilio_token)

          @client.messages
            .create(
              body: "Your Senpai verification code: #{verify_token}",
              from: '+22395',
              to: user.phone
            )

          token = JsonWebToken.encode(user_id: @user.id)
          { user: user, token: token }
        rescue ActiveRecord::RecordInvalid => e
          GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}: #{e.record.errors.full_messages.join(', ')}")
        end
      end
    end
  end