require 'rails_helper'

RSpec.describe Message, type: :model do
  describe "validating the model" do
    let(:a_valid_user) {
      User.new(name: "Homer Simpson")
    }

    before do
      expect(a_valid_user).to be_valid
    end

    it "requires a name" do
      expect {
        a_valid_user.name = nil
      }.to change {
        a_valid_user.valid?
      }.from(true).to(false).and change {
        a_valid_user.errors[:name]
      }.to include("can't be blank")
    end
  end

  describe "querying for a user's messages with another user" do
    let(:sender) { User.create(id: 11, name: "Bart Simpson") }
    let(:recipient) { User.create(id: 12, name: "Homer Simpson") }
    let(:another_user) { User.create(id: 13, name: "Ned Flanders") }

    before do
      sender.save!
      recipient.save!
      another_user.save!
    end

    it "returns messages between a sender and recipient" do
      first_message = Message.create!(body: "Eat my Shorts", sender: sender, recipient: recipient)
      second_message = Message.create!(body: "D'oh", sender: recipient, recipient: sender)
      message_for_ned = Message.create!(body: "Hello", sender: sender, recipient: another_user)
      another_message_for_ned = Message.create!(body: "World", sender: recipient, recipient: another_user)

      expect(sender.messages_from(recipient)).to contain_exactly(first_message, second_message)
      expect(recipient.messages_from(sender)).to contain_exactly(first_message, second_message)
      expect(sender.messages_from(recipient)).not_to include(message_for_ned, another_message_for_ned)
      expect(recipient.messages_from(sender)).not_to include(message_for_ned, another_message_for_ned)
    end
  end
end
