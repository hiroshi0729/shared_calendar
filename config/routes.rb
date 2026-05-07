Rails.application.routes.draw do
  # ログイン前のトップページ(ログイン画面を表示)
  root 'sessions#new'
  
  # ユーザー登録
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  
  # ログイン・ログアウト
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :events

  # 友達機能のルーティング
  resources :users, only: [:index]
  resources :users, only: [] do
    resources :friendships, only: [:create] do
      member do
        patch :accept
        patch :reject
      end
    end
  end
  
  resources :friendships, only: [:index, :destroy]

  # パスワードリセット
  resources :password_resets, only: [:new, :create, :edit, :update]
  
  # letter_opener_web のルーティング(開発環境のみ)
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
