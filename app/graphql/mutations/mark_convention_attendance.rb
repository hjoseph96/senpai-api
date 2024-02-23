module Mutations
  class MarkConventionAttendance < Mutations::BaseMutation
    argument :convention_id, ID
    argument :user_id, ID

    field :convention, Types::ConventionType, null: false

    def resolve(convention_id:, user_id:)
      @user = User.find(user_id)

      begin
        @convention = Convention.find(convention_id)

        @convention.attendees << @user
        @cconvention.save!

        { convention: @convention.reload }
      rescue ActiveRecord::RecordInvalid => e
        GraphQL::ExecutionError.new("#{e.record.errors.full_messages.join(', ')}")
      end
    end
  end
end