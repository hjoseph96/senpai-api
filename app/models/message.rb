class Message < ApplicationRecord
    include ActiveStorageValidations

    belongs_to :conversation
    belongs_to :sender, class_name: :User, foreign_key: 'sender_id'
    belongs_to :sticker, required: false
    has_one :recommendation, required: false

    has_one_attached :attachment

    validates :attachment, attached: true,  size: { less_than: 50.megabytes , message: 'is too large' }
    validates_presence_of :content


    enum :reaction, %w(funny like heart vomit angry demon)
  
    after_create_commit { MessageBroadcastJob.perform_async(self.id) }
end