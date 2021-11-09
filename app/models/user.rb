class User < ApplicationRecord
  has_many :sent_messages,
           class_name: "Message",
           foreign_key: :sender_id,
           dependent: :delete_all
  has_many :received_messages,
           class_name: "Message",
           foreign_key: :recipient_id,
           dependent: :delete_all

  def messages
    Message.where('recipient_id = :user_id OR sender_id = :user_id', user_id: self.id)
  end
end
