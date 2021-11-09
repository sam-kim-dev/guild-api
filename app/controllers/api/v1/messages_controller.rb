class Api::V1::MessagesController < ApplicationController
  def index
    @messages = Message.all

    render json: @messages
  end

  def create
    @message = Message.new(message_params)

    if @message.save
      render json: @message, status: :created
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

private

  def set_message
    @message = Message.find(params[:id])
  end

  def message_params
    params.require(:data)
          .permit(:body, :sender_id, :recipient_id)
  end
end
