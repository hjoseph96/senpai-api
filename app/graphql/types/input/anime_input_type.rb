module Types
    module Input
      class AnimeInputType < Types::BaseInputObject
        argument :title, String, required: true
        argument :page, Integer
      end
    end
end