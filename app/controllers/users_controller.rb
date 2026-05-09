class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      auto_login(@user)
      redirect_to root_path, notice: 'ユーザー登録が完了しました!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # ユーザー一覧
  def index
    @users = User.where.not(id: current_user.id)
  end
  
  # 友達のカレンダーを表示
  def calendar
    @user = User.find(params[:id])
    
    # 友達関係のチェック
    unless current_user.accepted_friends.include?(@user)
      redirect_to users_path, alert: '友達のカレンダーのみ表示できます'
      return
    end
    
    # カレンダー表示用の予定を取得
    @events = @user.events
  end
  
  private
  
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
