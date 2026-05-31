Rails.application.routes.draw do
    # Action Cable のマウント
    mount ActionCable.server => '/cable'
  # ログイン前のトップページ(ログイン画面を表示)
  root 'sessions#new'
  
  # ユーザー登録
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  
  # ログイン・ログアウト
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  # イベント
  resources :events
  
  # プロフィール編集
  resource :profile, only: [:edit, :update]
  
  # チャット機能のルーティング
  resources :chat_rooms, only: [:index, :show, :new, :create] do
    resources :messages, only: [:create]
    collection do
      get :direct_new  # 個人チャット作成用
    end
  end

  # プロフィール
  resource :profile, only: [:show, :edit, :update]

  # ユーザー一覧(友達一覧)とユーザー詳細
  resources :users, only: [:index, :show] do
    # 友達リクエスト送信
    resources :friendships, only: [:create] do
      member do
        patch :accept   # 友達リクエスト承認
        patch :reject   # 友達リクエスト拒否
      end
    end
  end
  
  # 友達リクエスト一覧と友達削除
  resources :friendships, only: [:index, :destroy]

  # パスワードリセット
  resources :password_resets, only: [:new, :create, :edit, :update]
  
  # letter_opener_web のルーティング(開発環境のみ)
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end