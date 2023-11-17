module Types
    module Input
      class AnimeInputType < Types::BaseInputObject
        argument :title, String, required: false
        argument :genre, String, required: false
        argument :page, Integer
      end
    end
end