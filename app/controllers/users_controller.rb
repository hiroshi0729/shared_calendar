class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]
  before_action :require_login, only: [:index, :show]  # 追加
  
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

  # ユーザー一覧 (承認済みの友達のみ表示)
  def index
    @friends = current_user.accepted_friends
  end
  
  # ユーザー詳細
  def show
    @user = User.find(params[:id])
    
    # 友達関係をチェック
    unless current_user.friends_with?(@user)
      redirect_to users_path, alert: 'このユーザーとは友達ではありません'
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name)
  end
end
