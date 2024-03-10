module Mutations
  class CreateEvent < Mutations::BaseMutation
    argument :params, Types::Input::EventInputType, required: true

    field :event, Types::EventType, null: false

    def resolve(params:)
      event_params = Hash params

      begin
        host = User.find(event_params[:user_id])

        location =  Geocoder.search(event_params[:full_address])[0]
        point = "POINT(#{location.longitude} #{location.latitude})"
        state = location.city == location.state ? location.country : location.state

        event = Event.new(
          host_id: host.id,
          title: event_params[:title],
          start_date: event_params[:start_date],
          country: location.country,
          display_city: location.city,
          display_state: state,
          lonlat: point,
          venue: event_params[:venue],
          description: event_params[:description],
          payment_required: event_params[:payment_required]
          )

        if event_params[:cover_image].present?
          file = event_params[:cover_image]
          blob = ActiveStorage::Blob.create_and_upload!(
            io: file.tempfile,
            filename: file.original_filename
          )
          event.cover_image.attach(blob)
        end

        if event_params[:end_date].present?
          event.end_date = event_params[:end_date]
        end

        if event_params[:convention_id].present?
          event.convention_id = event_params[:convention_id]
        end

        if event_params[:cosplay_required].present?
          unless %w(no optional required).include? event_params[:cosplay_required]
            return GraphQL::ExecutionError.new('Invalid cosplay_required setting.')
          end

          event.cosplay_required = event_params[:cosplay_required]
        end

        if event.save!
          Party.create!(
            event_id: event.id,
            host_id: event.host_id,
            member_limit: event_params[:member_limit]
          )

          { event: event.reload }
        end
      rescue ActiveRecord::RecordInvalid => e
        GraphQL::ExecutionError.new("#{e.record.errors.full_messages.join(', ')}")
      end
    end
  end
end