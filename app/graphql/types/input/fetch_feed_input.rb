# frozen_string_literal: true


module Types
  module Input
    class FetchFeedInput < Types::BaseInputObject
      argument :user_id, ID, required: true
      argument :miles_away, Integer, required: true
      argument :min_age, Integer, required: true
      argument :max_age, Integer, required: true
      argument :has_bio, Boolean, required: false
      argument :verified, Boolean, required: false
      argument :anime_ids, [ID], required: false
      argument :page, Integer, required: false
    end
  end
end