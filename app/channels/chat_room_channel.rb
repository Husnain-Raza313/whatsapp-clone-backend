# frozen_string_literal: true

class ChatRoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_room_#{params[:chat_room_id]}"
  end

  def unsubscribed
  end
end
