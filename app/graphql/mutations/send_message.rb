# frozen_string_literal: true

module Mutations
    class SendMessage < Mutations::BaseMutation
      graphql_name "SendMessage"
  
      argument :params, Types::Input::MessageInputType, required: true

      field :message, Types::MessageType, null: false
  
      def resolve(params:)
        @current_user = User.find(params[:sender_id])

        begin
          @conversation = Conversation.find(params[:conversation_id])

          message_params = {
            sender_id: params[:sender_id],
            conversation_id: @conversation.id,
            content: params[:content]
          }

          @message = Message.new(message_params)

          if params[:attachment].present?
            file = params[:attachment]
            blob = ActiveStorage::Blob.create_and_upload!(
                io: file.tempfile,
                filename: file.original_filename
            )
            @message.attachment.attach(blob)
          end

          @message.reaction = params[:reaction] if params[:reaction].present?

          if params[:sticker_id].present?
            @message.sticker = Sticker.find(params[:sticker_id])
          end

          if params[:recommended_anime_id].present?
            recommendee_id = @conversation.user_ids.reject{|i| i == @current_user.id}[0]

            @message.recommendation = Recommendation.new(
                user_id: @current_user.id,
                recommendee_id: recommendee_id,
                anime_id: params[:recommended_anime_id]
            )
          end

          @conversation.messages << @message
          @conversation.save!

          receiver = @conversation.users.where.not(id: @message.sender_id).first
          PushNotification.create(
            user_id: receiver.id,
            event_name: 'new_message',
            content: "#{@current_user.first_name} sent you a new message."
          )

          PushNotification.create(
            user_id: @current_user.id,
            event_name: 'sent_new_message',
            content: 'You sent a message.'
          )

          @message.sender.appear

          { message: @message.reload(lock: true) }
        rescue ActiveRecord::RecordInvalid => e
            GraphQL::ExecutionError.new("Invalid attributes for #{e.record.class}: #{e.record.errors.full_messages.join(', ')} and #{@message.errors.full_messages.join(', ')}")
        end
      end
    end
end