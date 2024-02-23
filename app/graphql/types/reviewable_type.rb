module Types
  class ReviewableType < Types::BaseUnion
    possible_types UserType, PartyType, EventType, ConventionType

    def self.resolve_type(obj, ctx)
      case obj.class
        when User then UserType
        when Party then PartyType
        when Event then EventType
        when Convention then ConventionType
      else
        raise StandardError.new("Incorrect object class.")
      end
    end
  end
end