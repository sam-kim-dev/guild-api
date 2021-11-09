require 'rails_helper'

RSpec.describe Message, type: :model do
  let(:sender) { User.create(id: 1, name: "Bart Simpson") }
  let(:recipient) { User.create(id: 2, name: "Homer Simpson") }

  before do
    sender.save!
    recipient.save!
  end

  describe "validating the model" do
    let(:a_valid_message) {
      Message.new(body: "Cowabunga, dude!", sender: sender, recipient: recipient)
    }

    before do
      expect(a_valid_message).to be_valid
    end

    it "requires a body" do
      expect {
        a_valid_message.body = nil
      }.to change {
        a_valid_message.valid?
      }.from(true).to(false).and change {
        a_valid_message.errors[:body]
      }.to include("can't be blank")
    end

    it "requires a sender" do
      expect {
        a_valid_message.sender = nil
      }.to change {
        a_valid_message.valid?
      }.from(true).to(false).and change {
        a_valid_message.errors[:sender]
      }.to include("must exist")
    end

    it "requies a recipient" do
      expect {
        a_valid_message.recipient = nil
      }.to change {
        a_valid_message.valid?
      }.from(true).to(false).and change {
        a_valid_message.errors[:recipient]
      }.to include("must exist")
    end
  end

  describe "querying for recent messages" do
    after do
      Message.recency_threshold_days = 30
    end

    it "returns messages within the threshold" do
      Message.recency_threshold_days = 1

      recent_message = Message.create!(
        created_at: (0.9).days.ago, body: "Cowabunga, dude!", sender: sender, recipient: recipient
      )
      not_a_recent_message = Message.create!(
        created_at: (1.1).days.ago, body: "Cowabunga, dude!", sender: sender, recipient: recipient
      )

      expect(Message.recent).to include(recent_message)
      expect(Message.recent).not_to include(not_a_recent_message)
    end
  end

  describe "limiting recent messages" do
    after do
      Message.recent_limit = 100
    end

    it "returns messages up to a limit" do
      recent_message = Message.create!(
        created_at: 1.minute.ago, body: "Cowabunga, dude!", sender: sender, recipient: recipient
      )
      not_a_recent_message = Message.create!(
        created_at: 1.minute.ago, body: "Cowabunga, dude!", sender: sender, recipient: recipient
      )

      expect {
        Message.recent_limit = 1
      }.to change {
        Message.recent.size
      }.from(2).to(1)
    end
  end
end
