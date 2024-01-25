# frozen_string_literal: true


module Types
  module Input
    class FetchCharactersInputType < Types::BaseInputObject
      argument :character_name, String, required: true
      argument :genre, String, required: false
      argument :page, Integer, required: false
    end
  end
end