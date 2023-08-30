# frozen_string_literal: true

module Mutations
  class AnswerVerifyRequest < Mutations::BaseMutation
    graphql_name "AnswerVerifyRequest"

    argument :user_id, ID, required: true
    argument :verify_request_id, ID, required: true
    argument :decision, String, required: true

    field :verify_request, Types::VerifyRequestType, null: false

    def resolve(user_id:, verify_request_id:, decision:)
      @current_user = User.find(user_id)

      unless @current_user.present? && @current_user.on_the_team?
        return GraphQL::ExecutionError.new("No admin or mod found")
      end

      @request = VerifyRequest.find(verify_request_id)
      return GraphQL::ExecutionError.new("No admin or mod found") unless request.present?

      case decision
        when 'approved' then @request.approve!
        when 'denied' then @request.deny!
      end

      { verify_request: @request }
    end
  end
end
