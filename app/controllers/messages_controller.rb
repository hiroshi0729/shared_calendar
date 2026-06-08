class MessagesController < ApplicationController
  before_action :require_login
  before_action :set_chat_room

  # メッセージ作成
  def create
    @message = @chat_room.messages.build(message_params)
    @message.user = current_user
    @message.read = true  # 🆕 自分が送ったメッセージは既読にする

    if @message.save
      redirect_to @chat_room, notice: 'メッセージを送信しました'
    else
      @messages = @chat_room.messages.not_deleted.includes(:user).order(created_at: :asc)  # 🆕 not_deleted を追加
      flash.now[:alert] = 'メッセージの送信に失敗しました'
      render 'chat_rooms/show', status: :unprocessable_entity
    end
  end

  private

  def set_chat_room
    @chat_room = ChatRoom.find(params[:chat_room_id])
  end

  def message_params
    # :image パラメータを追加
    params.require(:message).permit(:content, :image)
  end
end