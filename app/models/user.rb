class User < ApplicationRecord
  has_many :sent_messages,
           class_name: "Message",
           foreign_key: :sender_id,
           dependent: :delete_all
  has_many :received_messages,
           class_name: "Message",
           foreign_key: :recipient_id,
           dependent: :delete_all

  validates :name, presence: true

  def messages
    received_messages.or(sent_messages)
  end

  def recent_messages
    messages.recent
  end

  def messages_from(user)
    received_messages.where(sender: user).or(sent_messages.where(recipient: user)).recent
  end
end
