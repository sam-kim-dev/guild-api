class Api::V1::MessagesController < ApplicationController
  def index
    @messages = current_user.recent_messages

    render json: @messages
  end

  def show
    sender = User.find(params.require(:user_id))
    @messages = current_user.messages_from(sender)

    render json: @messages
  end

  def create
    @message = Message.new(message_params.merge(sender: current_user))

    if @message.save
      render json: @message, status: :created
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

private

  def message_params
    params.require(:data)
          .permit(:body, :recipient_id)
  end
end
