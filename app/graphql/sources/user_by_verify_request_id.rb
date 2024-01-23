module Sources
  class UserByVerifyRequestId < GraphQL::Dataloader::Source
    def fetch(verify_request_ids)
      records = {}

      VerifyRequest.includes(:user).where(id: verify_request_ids).each do |verify_request|
        records[verify_request.id] = verify_request.user
      end

      verify_request_ids.map { |id| records[id] }
    end
  end
end