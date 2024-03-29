module Types
  class CornerableType < Types::BaseUnion
    possible_types CharacterType, AnimeType

    def self.resolve_type(obj, ctx)
      return CharacterType if obj.class == Character

      return AnimeType if obj.class == Anime

      raise StandardError.new("Incorrect object class.")
    end
  end
end