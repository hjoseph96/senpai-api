# frozen_string_literal: true

module Mutations
  class SendPartyMessage < Mutations::BaseMutation
    graphql_name "SendPartyMessage"

    argument :params, Types::Input::PartyMessageInputType, required: true

    field :message, Types::PartyMessageType, null: false

    def resolve(params:)
      @current_user = User.find(params[:sender_id])

      begin
        @party = Party.find(params[:party_id])
        @party_chat = @party.party_chat

        unless @party.all_participants.pluck(:id).include? params[:sender_id]
          return GraphQL::ExecutionError.new('Message sender is not a party member')
        end

        message_params = {
          sender_id: params[:sender_id],
          party_chat_id: @party.party_chat.id,
          content: params[:content]
        }

        @message = PartyMessage.new(message_params)

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

        @party_chat.messages << @message
        @party_chat.save!

        receivers = @party.all_participants.where.not(id: @message.sender_id)
        receivers.each do |r|
          PushNotification.create(
            user_id: r.id,
            event_name: 'new_message',
            content: "#{@current_user.first_name} sent a new message to party chatroom."
          )
        end

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