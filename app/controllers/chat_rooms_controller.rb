class ChatRoomsController < ApplicationController
  before_action :require_login
  before_action :set_chat_room, only: [:show]

  # チャットルーム一覧
  def index
    @chat_rooms = ChatRoom.includes(:messages).order(created_at: :desc)
  end

  # チャットルーム作成フォーム（追加）
  def new
    @chat_room = ChatRoom.new
  end

  # チャットルーム詳細
  def show
    @messages = @chat_room.messages.includes(:user).order(created_at: :asc)
    @message = Message.new
  end

  # チャットルーム作成
  def create
    @chat_room = ChatRoom.new(chat_room_params)

    if @chat_room.save
      redirect_to @chat_room, notice: 'チャットルームを作成しました'
    else
      # エラー時は new.html.erb を再表示
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_chat_room
    @chat_room = ChatRoom.find(params[:id])
  end

  def chat_room_params
    params.require(:chat_room).permit(:name)
  end
end
