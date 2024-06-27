module Types
  module Input
    class BackgroundSettingsInputType < Types::BaseInputObject
      argument :user_id, ID, required: true
      argument :title, String, required: true
      argument :sky_color, String, required: true
      argument :equator_color, String, required: true
      argument :ground_color, String, required: true
      argument :enable_clouds, Boolean, required: true
      argument :enable_stars, Boolean, required: true
    end
  end
end