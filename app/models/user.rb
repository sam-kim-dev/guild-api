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
    Message.recent
           .where(
             'recipient_id = :user_id OR sender_id = :user_id', user_id: self.id
           )
  end

  def recent_received_messages
    received_messages.recent
  end

  def messages_from(user)
    received_messages.where(sender: user).or(sent_messages.where(recipient: user)).recent
  end
end
