class DestroyUsersJob
    include Sidekiq::Job

    def perform
        deleted_users = User.where.not(deleted_at: nil)
        
        deleted_users.find_in_batches do |group|
            group.each do |u|
                u.destroy_fully! if 30.days.ago > u.deleted_at
            end
        end
    end
end