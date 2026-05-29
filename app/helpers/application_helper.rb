module ApplicationHelper
 # ユーザーのアバターを表示
 def user_avatar(user, size: 'w-10 h-10')
    if user.avatar.attached?
      # 画像がアップロードされている場合
      image_tag user.avatar, class: "#{size} rounded-full object-cover"
    else
      # 画像がない場合は頭文字を表示
      content_tag :div, class: "#{user_avatar_color(user)} text-white rounded-full #{size} flex items-center justify-center font-bold flex-shrink-0" do
        user_initial(user)
      end
    end
  end

  # ユーザー名の頭文字を取得
  def user_initial(user)
    user.email.first.upcase
  end

  # ユーザーごとに異なる背景色を生成
  def user_avatar_color(user)
    colors = %w[
      bg-blue-500
      bg-green-500
      bg-yellow-500
      bg-red-500
      bg-purple-500
      bg-pink-500
      bg-indigo-500
      bg-teal-500
    ]
    colors[user.id % colors.length]
  end
end
