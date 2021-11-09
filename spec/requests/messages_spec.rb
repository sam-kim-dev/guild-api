require 'rails_helper'

RSpec.describe "api/v1/messages", type: :request do
  let(:sender) { User.create(id: 1, name: "Bart Simpson") }
  let(:recipient) { User.create(id: 2, name: "Homer Simpson") }

  let(:valid_attributes) {
    {
      "data": {
        "body": "Cowabunga, dude",
        "recipient_id": recipient.id,
      }
    }
  }

  let(:invalid_attributes) {
    {
      "data": {
        "body": "Cowabunga, dude",
        "recipient_id": nil,
      }
    }
  }

  before do
    sender.save!
    recipient.save!
  end

  describe "GET /index" do
    it "renders a successful response" do
      get api_v1_messages_url, as: :json
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      get api_v1_sender_messages_url(recipient), as: :json
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Message" do
        expect {
          post api_v1_messages_url,
               params: valid_attributes, as: :json
        }.to change(Message, :count).by(1)
      end

      it "renders a JSON response with the new message" do
        post api_v1_messages_url,
             params: valid_attributes, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Message" do
        expect {
          post api_v1_messages_url,
               params: invalid_attributes, as: :json
        }.to change(Message, :count).by(0)
      end

      it "renders a JSON response with errors for the new message" do
        post api_v1_messages_url,
             params: invalid_attributes, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end
    end
  end
end
