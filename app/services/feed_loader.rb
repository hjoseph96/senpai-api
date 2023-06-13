class FeedLoader
    def initialize(user_id:)
        new.create_feed(user_id)
    end

    def create_feed(user_id:)
        @user = User.find(user_id)

        rejects = @user.likes.where(like_type: :rejection).pluck(:likee_id)

        user_pool = User.where(current_sign_in_at: 1.month.ago..Date.today)

        if @user.desires_women?
            user_pool = user_pool.where(gender: :female)
        else
            user_pool = user_pool.where(gender: :male)
        end

        user_location = Geocoder.search(@user.last_sign_in_ip)

        order_by_similarity(user_pool)
    end

    def order_by_similarity(user_pool, user_latlong)
        location_weight = 0.7

        ranks = {}
        user_pool.find_in_batches(start: 1000) do |group|
            group.each do |u|
                location = Geocoder.search(u.last_sign_in_at)
                distance = Geocoder.distance_between(user_latlong[0], user_latlong,[1], location[0], location[1])
                ranks[u.id] = {
                    distance: distance / location_weight,
                    anime_similarity_score: anime_similarity_score(@user, u)
                }
            end
        end

        feed = ranks.sort_by {|k, v| v[:distance] }.reverse
        feed = feed.sort_by {|k, v| v[:anime_similarity_score] }

        User.where(id: feed.values)
    end

    def anime_similarity_score(current_user, potential_match)
        same_taste_score = (current_user.anime_ids & potential_match.anime_ids).count * 0.7

        user_genre_list = current_user.animes.pluck(:genres).flatten.uniq
        match_genre_list = potential_match.animes.pluck(:genres).flatten.uniq
        same_genre_score = (user_genre_list & match_genre_list).count * 0.4

        same_genre_score + same_taste_score
    end
end