Rails.application.routes.draw do
  get 'home/index'
  root 'home#index'
  
  # ユーザー登録
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  
  # ログイン・ログアウト
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

    # パスワードリセット
    resources :password_resets, only: [:new, :create, :edit, :update]
    # letter_opener_web のルーティング(開発環境のみ)
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
