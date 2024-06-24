module Mutations
  class SeedAvatars < Mutations::BaseMutation
    argument :params, [Types::Input::AvatarInputType], required: true

    field :avatars, Types::AvatarType, null: false

    def resolve(params:)
      begin
        avatar_roster_data = params

        avatar_roster_data.each do |avatar|
          next if Avatar.exists?(guid: avatar[:guid]) # Only create new root avatars for new Avatars

          new_avatar = Avatar.new(
            user_id: nil,     # Root avatars have no associated user
            is_default: nil,  # This field is for user's inventory Avatars
            guid: avatar[:guid],
            name: avatar[:name]
          )

          if params[:photo].present?
            file = params[:photo]
            blob = ActiveStorage::Blob.create_and_upload!(
              io: file.tempfile,
              filename: file.original_filename
            )
            new_avatar.attachment.attach(blob)
          end

          if params[:thumbnail].present?
            file = params[:thumbnail]
            blob = ActiveStorage::Blob.create_and_upload!(
              io: file.tempfile,
              filename: file.original_filename
            )
            new_avatar.attachment.attach(blob)
          end

          new_avatar.save
        end
      rescue ActiveRecord::RecordInvalid => e
        GraphQL::ExecutionError.new("#{e.record.errors.full_messages.join(', ')}")
      end
    end
  end
end