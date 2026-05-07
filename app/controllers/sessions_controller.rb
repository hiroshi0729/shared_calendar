class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]
  
  def new
    # ログイン画面を表示
  end
  
  def create
    @user = login(params[:email], params[:password])
    
    # デバッグ用のログ出力
    Rails.logger.debug "ログイン結果: #{@user.inspect}"
    Rails.logger.debug "パラメータ: #{params[:email]}"
    
    if @user
      redirect_to events_path, success: 'ログインしました'
    else
      flash.now[:danger] = 'ログインに失敗しました'
      render :new, status: :unprocessable_entity
    end
  end
  
  def destroy
    logout
    redirect_to root_path, success: 'ログアウトしました'  # root_path = ログイン画面
  end
end
