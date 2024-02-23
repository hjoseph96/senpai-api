
module Types
  module Input
    class ReviewInputType < Types::BaseInputObject
      argument :user_id, ID, required: true
      argument :score, Float, required: true
      argument :review_type, String, required: true
      argument :reviewable_type, String, required: true
      argument :reviewable_id, ID, required: true
      argument :feedback, String
    end
  end
end