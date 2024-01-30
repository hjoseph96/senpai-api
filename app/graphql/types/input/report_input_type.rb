
module Types
    module Input
      class ReportInputType < Types::BaseInputObject
        argument :offense_id, ID, required: true
        argument :reason, String, required: true
        argument :conversation_id, String, required: true
      end
    end
end