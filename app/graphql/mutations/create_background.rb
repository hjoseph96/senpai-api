module Mutations
  class CreateBackground < Mutations::BaseMutation
    argument :params, Types::Input::BackgroundSettingsInputType, required: true

    field :event, Types::BackgroundSettingType, null: false

    def resolve(params:)
      begin
        @user = User.find(params[:user_id])

        unless @user.present?
          GraphQL::ExecutionError.new("User cannot be found")
        end

        BackgroundSetting.create!(
          user_id: params[:user_id],
          title: params[:title],
          sky_color: params[:sky_color],
          equator_color: params[:equator_color],
          ground_color: params[:ground_color],
          enable_clouds: params[:enable_clouds],
          enable_stars: params[:enable_stars]
        )
      rescue ActiveRecord::RecordInvalid => e
        GraphQL::ExecutionError.new("#{e.record.errors.full_messages.join(', ')}")
      end
    end
  end
end