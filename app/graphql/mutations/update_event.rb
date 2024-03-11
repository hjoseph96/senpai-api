# frozen_string_literal: true

module Mutations
  class UpdateEvent < Mutations::BaseMutation
    graphql_name "UpdateEvent"

    argument :params, Types::Input::EventUpdateInputType, required: true

    field :event, Types::EventType, null: false

    def resolve(params:)
      event_params = Hash params

      @current_user = User.find(event_params[:user_id])
      @event = Event.find(event_params[:event_id])

      begin
        @event.title = event_params[:title] if event_params[:title].present?
        @event.venue = event_params[:venue] if event_params[:venue].present?
        @event.start_date = event_params[:start_date] if event_params[:start_date].present?
        @event.end_date = event_params[:end_date] if event_params[:end_date].present?
        @event.description = event_params[:description] if event_params[:description].present?
        @event.convention_id = event_params[:convention_id] if event_params[:convention_id].present?

        if event_params[:full_address].present?
          location =  Geocoder.search(event_params[:full_address])[0]

          point = "POINT(#{location.longitude} #{location.latitude})"
          state = location.city == location.state ? location.country : location.state

          place = location.instance_values['place']
          city = location.city || place.sub_municipality || place.region

          @event.display_city = city
          @event.display_state = state
          @event.country = location.country
          @event.lonlat = point
          @event.full_address = event_params[:full_address]
        end

        if event_params[:cover_image].present?
          file = event_params[:cover_image]
          blob = ActiveStorage::Blob.create_and_upload!(
            io: file.tempfile,
            filename: file.original_filename
          )
          @event.cover_image.attach(blob)
        end

        if event_params[:cosplay_required].present?
          unless %w(no optional required).include? event_params[:cosplay_required]
            return GraphQL::ExecutionError.new('Invalid cosplay_required setting.')
          end

          @event.cosplay_required = event_params[:cosplay_required]
        end

        if event_params[:member_limit].present?
          if event_params[:member_limit] < @event.party.members.count
            return GraphQL::ExecutionError.new("Cannot set limit lower than current party members.")
          end

          @event.party.member_limit = event_params[:member_limit]
        end

        @event.save!

        { event: @event.reload }
      rescue ActiveRecord::RecordInvalid => e
        GraphQL::ExecutionError.new("#{e.record.errors.full_messages.join(', ')}")
      end
    end
  end
end