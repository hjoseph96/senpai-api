namespace :senpai do
  task :all_users_like, [:gender, :user_id, :like_type] => [:environment] do |t, args|
    User.where(gender: args[:gender]).each do |u|
      @like = Like.create(user_id: u.id, likee_id: args[:user_id], like_type: args[:like_type])
      UserLike.create(user_id: u.id, like_id: @like.id)
    end
  end
end