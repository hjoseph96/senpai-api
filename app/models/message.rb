class Message < ApplicationRecord
    belongs_to :conversation
    belongs_to :sender, class_name: :User, foreign_key: 'sender_id'
  
    validates_presence_of :content

    enum :reaction, %w(funny like heart vomit angry demon)
  
    after_create_commit { MessageBroadcastJob.perform_async(self.id) }
end