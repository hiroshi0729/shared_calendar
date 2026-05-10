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
  
  # JSON リクエストに対応
  respond_to do |format|
    format.html # calendar.html.erb を表示
    format.json do
      # 自分のカレンダーか友達のカレンダーかで返すデータを変える
      if @user == current_user
        # 自分のカレンダー: タイトルと詳細を返す
        render json: @events.map { |event|
          {
            id: event.id,
            title: event.title,
            start: event.start_time.iso8601,
            end: event.end_time.iso8601,
            description: event.description,
            extendedProps: {
              description: event.description
            }
          }
        }
      else
        # 友達のカレンダー: 「予定あり」のみ返す
        render json: @events.map { |event|
          {
            id: event.id,
            title: '予定あり',
            start: event.start_time.iso8601,
            end: event.end_time.iso8601,
            color: '#6c757d', # グレー色で表示
            extendedProps: {
              isPrivate: true # プライベート情報フラグ
            }
          }
        }
      end
    end
  end
end
  
  private
  
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
