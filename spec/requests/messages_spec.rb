require 'rails_helper'

RSpec.describe "api/v1/messages", type: :request do
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  describe "GET /index" do
    it "renders a successful response" do
      Message.create! valid_attributes
      get messages_url, headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      message = Message.create! valid_attributes
      get message_url(message), as: :json
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Message" do
        expect {
          post messages_url,
               params: { message: valid_attributes }, headers: valid_headers, as: :json
        }.to change(Message, :count).by(1)
      end

      it "renders a JSON response with the new message" do
        post messages_url,
             params: { message: valid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to match(a_string_including("application/json"))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Message" do
        expect {
          post messages_url,
               params: { message: invalid_attributes }, as: :json
        }.to change(Message, :count).by(0)
      end

      it "renders a JSON response with errors for the new message" do
        post messages_url,
             params: { message: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq("application/json")
      end
    end
  end
end
