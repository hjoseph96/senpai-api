module Mutations
    class ResendVerifyText < Mutations::BaseMutation
      argument :phone, String, required: true
  
      field :status, Integer, null: false
      field :user, Types::UserType
  
      def resolve(phone:)
        @user = User.find_by(phone: phone)

        unless @user.present?
          @user = User.with_deleted.find_by(phone: phone)

          if @user.nil? || @user.banned?
            return GraphQL::ExecutionError.new("No user found")
          else
            @user.recover(recursive: true)
          end
        end

        return { status: 404 } unless @user.present?
        return { user: @user } if phone == '+17777777777'
  
        verify_token = (SecureRandom.random_number(9e5) + 1e5).to_i
        @user.password = verify_token
        @user.save

        twilio_sid = Rails.application.credentials.twilio_sid
        twilio_token = Rails.application.credentials.twilio_token
        @client = Twilio::REST::Client.new(twilio_sid, twilio_token)
        @client.messages.create(
            body: "Your Senpai verification code: #{verify_token}",
            from: '+17183072924',
            to: @user.phone
        )

        { user: @user }
      end
    end
  end