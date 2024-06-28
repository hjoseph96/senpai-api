module Queries
  class FetchAnimeSimilarityScore < Queries::BaseQuery
    graphql_name "FetchAnimeSimilarityScore"

    argument :user_id, ID, required: true
    argument :other_user_id, ID, required: true

    type Float, null: false

    def resolve(user_id:, other_user_id:)
      @user = User.find(user_id)
      @other_user = User.find(other_user_id)

      @user.anime_similarity_score(@other_user)
    end
  end
end