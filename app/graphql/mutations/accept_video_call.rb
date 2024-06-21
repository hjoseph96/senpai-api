module Mutations
  class AcceptVideoCall < Mutations::BaseMutation
    argument :user_id, ID, required: true
    argument :matchee_id, ID, required: true

    field :video_match, String

    def resolve(user_id:, matchee_id:)
      @user = User.find(user_id)
      @matchee = User.find(matchee_id)

      match = VideoMatch.create!(
        user_id: user_id,
        matchee_id: @matchee.id
      )

      if @user.update(awaiting_match: false) && @matchee.update(awaiting_match: false)
        { video_match: match }
      end
    end
  end
end
