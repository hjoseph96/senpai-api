
module Types
    module Input
      class ReportInputType < Types::BaseInputObject
        argument :user_id, Integer, required: true
        argument :offense_id, Integer, required: true
        argument :reason, Integer, required: true
        argument :conversation_id, String, required: true
      end
    end
end