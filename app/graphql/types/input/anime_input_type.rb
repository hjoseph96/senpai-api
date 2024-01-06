module Types
    module Input
      class AnimeInputType < Types::BaseInputObject
        argument :title, String, required: false
        argument :genres, [String], required: false
        argument :page, Integer, required: false
      end
    end
end