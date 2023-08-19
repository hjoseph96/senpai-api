class Message < ApplicationRecord
    belongs_to :conversation
    belongs_to :sender, class_name: :User, foreign_key: 'sender_id'
    belongs_to :sticker, required: false
  
    validates_presence_of :content

    has_one_attached :attachment

    enum :reaction, %w(funny like heart vomit angry demon)
  
    after_create_commit { MessageBroadcastJob.perform_async(self.id) }
end