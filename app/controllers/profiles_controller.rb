class ProfilesController < ApplicationController
  before_action :require_login

  # プロフィール表示(マイページ)
  def show
    @user = current_user
    @friends = current_user.friends # 友達一覧を取得
  end

  # プロフィール編集画面
  def edit
    @user = current_user
  end

  # プロフィール更新
  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to profile_path, success: 'プロフィールを更新しました'
    else
      flash.now[:danger] = 'プロフィールを更新できませんでした'
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    # last_name と first_name ではなく、name を使用する
    params.require(:user).permit(:email, :name, :avatar)
  end
end
