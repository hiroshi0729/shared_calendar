class ApplicationController < ActionController::Base
  # CSRF対策
  protect_from_forgery with: :exception
  
  # フラッシュメッセージの設定
  add_flash_types :success, :info, :warning, :danger
  
  # ログイン必須にする(全コントローラーに適用)
  before_action :require_login
  
  private
  
  def not_authenticated
    # 未ログイン時はログイン画面にリダイレクト
    redirect_to login_path, warning: 'ログインしてください'
  end
end
