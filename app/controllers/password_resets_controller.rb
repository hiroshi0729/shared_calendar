class PasswordResetsController < ApplicationController
    skip_before_action :require_login
    
    # パスワードリセット申請画面
    def new
    end
    
    # パスワードリセットメール送信
    def create
      @user = User.find_by(email: params[:email])
      
      if @user.present?
        @user.deliver_reset_password_instructions!
      end
      
      # セキュリティ上、メールアドレスの存在を特定されないよう、常に同じメッセージを表示
      redirect_to login_path, notice: 'パスワードリセット手順を送信しました'
    end
    
    # パスワードリセット画面
    def edit
      @token = params[:id]
      @user = User.load_from_reset_password_token(@token)
      
      if @user.blank?
        redirect_to root_path, alert: 'トークンが無効です'
      end
    end
    
    # パスワード更新
    def update
      @token = params[:id]
      @user = User.load_from_reset_password_token(@token)
      
      if @user.blank?
        redirect_to root_path, alert: 'トークンが無効です'
        return
      end
      
      @user.password_confirmation = params[:user][:password_confirmation]
      
      if @user.change_password(params[:user][:password])
        redirect_to login_path, notice: 'パスワードが更新されました'
      else
        flash.now[:alert] = 'パスワードの更新に失敗しました'
        render :edit, status: :unprocessable_entity
      end
    end
  end
