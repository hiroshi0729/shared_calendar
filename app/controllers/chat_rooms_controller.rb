class ChatRoomsController < ApplicationController
  before_action :require_login
  before_action :set_chat_room, only: [:show]

  # チャットルーム一覧
  def index
    @chat_rooms = current_user.chat_rooms
                               .includes(:users, :messages)
                               .order(created_at: :desc)
  end

  # チャットルーム詳細
  def show
    @messages = @chat_room.messages.includes(:user).order(created_at: :asc)
    @message = Message.new
  end

  # 個人チャット作成画面
  def direct_new
    @chat_room = ChatRoom.new  # ← 追加
    # 自分以外のユーザーを取得
    @users = User.where.not(id: current_user.id)
  end

  # グループチャット作成画面
  def new
    @chat_room = ChatRoom.new
    # 自分以外のユーザーを取得
    @users = User.where.not(id: current_user.id)
  end

  # チャットルーム作成
  def create
    @chat_room = ChatRoom.new(chat_room_params)
    
    if @chat_room.save
      # 作成者をメンバーに追加
      @chat_room.chat_room_memberships.create!(user: current_user)
      
      # 選択されたユーザーをメンバーに追加
      if params[:user_ids].present?
        params[:user_ids].each do |user_id|
          @chat_room.chat_room_memberships.create!(user_id: user_id)
        end
      end
      
      redirect_to chat_room_path(@chat_room), success: 'チャットルームを作成しました'
    else
      if @chat_room.direct_message?
        @users = User.where.not(id: current_user.id)
        render :direct_new, status: :unprocessable_entity
      else
        @users = User.where.not(id: current_user.id)
        render :new, status: :unprocessable_entity
      end
    end
  end

  private

  def set_chat_room
    @chat_room = current_user.chat_rooms.find(params[:id])
  end

  def chat_room_params
    params.require(:chat_room).permit(:name, :room_type)
  end
end