class FeedLoader
    def self.create_feed(user_id:, distance_in_miles: 40)
        new.create_feed(user_id: user_id, distance_in_miles: distance_in_miles)
    end

    def create_feed(user_id:, distance_in_miles:)
        @user = User.find(user_id)
        @miles = distance_in_miles

        rejects = @user.likes.where(like_type: :rejection).pluck(:likee_id)

        pool = User.within(@user.lonlat.latitude, @user.lonlat.longitude, 40)
                        .where(current_sign_in_at: 1.month.ago..DateTime.now)

        if @user.desires_women?
            pool = pool.where(gender: :female)
        elsif @user.desires_men?
            pool = pool.where(gender: :male)
        elsif @user.desires_both?
            pool = pool.where(gender: [:male, :female])
        end

        return [] unless pool.present?
        
        user_pool = randomize_users(pool, rejects)

        order_by_similarity(user_pool)
    end

    def randomize_users(pool, reject_ids)
        user_pool = []

        # Show super likers first
        super_likers = User.joins(:likes).where(likes: { like_type: :super, likee_id: @user.id })
        if super_likers.present?
            super_likers.each do |s|
                next if @user.has_liked?(s) || @user.matched_with?(s) || @user.blocked?(s)
                next unless want_each_other?(@user, s)

                user_pool << s
            end
        end

        (50 - user_pool.count).times do
            u = pool.sample

            next if @user.has_liked?(u) || @user.matched_with?(u) || @user.blocked?(u)
            next unless want_each_other?(@user, u)

            user_pool << pool.sample
        end

        ids = user_pool.map(&:id).uniq - reject_ids

        User.where(id: ids)
    end

    def want_each_other?(user, other_user)
        if user.male?
            if other_user.female?
                likes_girls = user.desires_women? || user.desires_both?
                she_likes_men = other_user.desires_men? || other_user.desires_both?
                return likes_girls && she_likes_men
            end

            if other_user.male?
                likes_men = user.desires_men? || user.desires_both?
                he_likes_men = other_user.desires_men? || other_user.desires_both?
                return  likes_men && he_likes_men
            end
        elsif user.female?
            if other_user.female?
                likes_girls = user.desires_women? || user.desires_both?
                she_likes_women = other_user.desires_women? || other_user.desires_both?
                return likes_girls && she_likes_women
            end

            if other_user.male?
                likes_men = user.desires_men? || user.desires_both?
                he_likes_women = other_user.desires_women? || other_user.desires_both?
                return  likes_men && he_likes_women
            end
        end
    end

    def order_by_similarity(user_pool)
        location_weight = 0.7

        ranks = {}
        user_pool.find_in_batches do |group|
            group.each do |u|
                distance = calculate_distance(u)

                ranks[u.id] = {
                  distance: distance / location_weight,
                  anime_similarity_score: anime_similarity_score(u)
                }
            end
        end

        feed = ranks.sort_by {|k, v| v[:distance] }.reverse.to_h
        feed = feed.sort_by {|k, v| v[:anime_similarity_score] }.reverse.to_h

        User.where(id: feed.keys).in_order_of(:id, feed.keys)
    end

    def calculate_distance(other_user)
        p1 = RGeo::Geographic.spherical_factory.point(@user.lonlat.longitude, @user.lonlat.latitude)

        p2 = RGeo::Geographic.spherical_factory.point(other_user.lonlat.longitude, other_user.lonlat.latitude)

        p1.distance(p2) / 1609.34
    end

    def anime_similarity_score(potential_match)
        same_taste_score = (@user.anime_ids & potential_match.anime_ids).count * 0.7

        user_genre_list = @user.animes.pluck(:genres).flatten.uniq
        match_genre_list = potential_match.animes.pluck(:genres).flatten.uniq
        same_genre_score = (user_genre_list & match_genre_list).count * 0.4

        score = same_genre_score + same_taste_score

        score *= 1.5 if potential_match.premium?

        score
    end
end