module Sources
  class AnimeByRecommendationId < GraphQL::Dataloader::Source
    def fetch(recommendation_ids)
      records = {}

      Recommendation.includes(:anime).where(id: recommendation_ids).each do |recommendation|
        records[recommendation.id] = recommendation.anime
      end

      recommendation_ids.map { |id| records[id] }
    end
  end
end