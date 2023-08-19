class FeedLoader
    def self.create_feed(user_id:)
        new.create_feed(user_id: user_id)
    end

    def create_feed(user_id:)
        @user = User.find(user_id)

        rejects = @user.likes.where(like_type: :rejection).pluck(:likee_id)

        user_pool = User.where(current_sign_in_at: 1.month.ago..DateTime.now)

        if @user.desires_women?
            user_pool = user_pool.where(gender: :female)
        else
            user_pool = user_pool.where(gender: :male)
        end

        user_location = Geocoder.search(@user.current_sign_in_ip)[0].data['loc'].split(',')

        order_by_similarity(user_pool, user_location)
    end

    def order_by_similarity(user_pool, user_latlong)
        location_weight = 0.7

        ranks = {}
        user_pool.find_in_batches do |group|
            group.each do |u|
                next if @user.has_liked?(u) || @user.matched_with?(u)
                
                location = Geocoder.search(u.current_sign_in_ip)[0].data['loc'].split(',')
                distance = Geocoder::Calculations.distance_between(user_latlong, location, units: :mi)
                
                ranks[u.id] = {
                    distance: distance / location_weight,
                    anime_similarity_score: anime_similarity_score(@user, u)
                }
            end
        end

        feed = ranks.sort_by {|k, v| v[:distance] }.reverse.to_h
        feed = feed.sort_by {|k, v| v[:anime_similarity_score] }.to_h

        User.where(id: feed.keys)
    end

    def anime_similarity_score(current_user, potential_match)
        same_taste_score = (current_user.anime_ids & potential_match.anime_ids).count * 0.7

        user_genre_list = current_user.animes.pluck(:genres).flatten.uniq
        match_genre_list = potential_match.animes.pluck(:genres).flatten.uniq
        same_genre_score = (user_genre_list & match_genre_list).count * 0.4

        score = same_genre_score + same_taste_score

        score *= 1.5 if potential_match.premium?
    end
end