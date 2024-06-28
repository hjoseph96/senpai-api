module Mutations
  class SeedAvatars < Mutations::BaseMutation
    require 'base64'

    argument :params, [Types::Input::AvatarInputType], required: true

    field :avatars, [Types::AvatarType], null: false

    def resolve(params:)
      begin
        avatar_roster_data = params

        avatars = []
        avatar_roster_data.each do |avatar|
          next if Avatar.exists?(guid: avatar[:guid]) # Only create new root avatars for new Avatars

          @tmp_path = "#{Rails.root}/tmp"

          new_avatar = Avatar.new(
            user_id: nil,     # Root avatars have no associated user
            is_default: nil,  # This field is for user's inventory Avatars
            guid: avatar[:guid],
            price: avatar[:price],
            name: avatar[:name],
            gender: avatar[:gender],
          )

          if avatar[:photo].present?
            filename = "#{SecureRandom.uuid}-avatar-photo.png"
            file_path = "#{@tmp_path}/#{filename}"
            File.open(file_path, 'wb') do |f|
              f.write(Base64.decode64(avatar[:photo]))
            end

            file = File.open(file_path)
            
            blob = ActiveStorage::Blob.create_and_upload!(
              io: file,
              filename: filename
            )
            new_avatar.photo.attach(blob)

            File.delete(file_path)
          end

          if avatar[:thumbnail].present?
            filename = "#{SecureRandom.uuid}-avatar-thumbnail.png"
            file_path = "#{@tmp_path}/#{filename}"
            File.open(file_path, 'wb') do |f|
              f.write(Base64.decode64(avatar[:thumbnail]))
            end

            file = File.open(file_path)

            blob = ActiveStorage::Blob.create_and_upload!(
              io: file,
              filename: filename
            )
            new_avatar.thumbnail.attach(blob)

            File.delete(file_path)
          end

          new_avatar.save

          avatars << new_avatar
        end

        { avatars: avatars }
      rescue => e
        GraphQL::ExecutionError.new("#{e.record.errors.full_messages.join(', ')}")
      end
    end
  end
end