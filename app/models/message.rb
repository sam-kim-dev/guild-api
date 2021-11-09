class Message < ApplicationRecord
  belongs_to :recipient,
             class_name: "User"
  belongs_to :sender,
             class_name: "User"

  class_attribute :recency_threshold_days,
                  default: Integer(ENV.fetch("MESSAGE_RECENCY_THRESHOLD_DAYS", 30))

  class_attribute :recent_limit,
                  default: Integer(ENV.fetch("RECENT_LIMIT", 100))

  scope :recent, -> {
    where('created_at > ?', recency_threshold_days.days.ago).limit(recent_limit)
  }
end
