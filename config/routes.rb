Rails.application.routes.draw do
  root to: "scheduled_messages#index"

  match "/auth/:provider/callback" => "auth#oauth_callback", via: [:get]

  resources :employees, only: [:new, :create, :index, :edit, :update, :destroy]
  resources :users, only: [:edit, :update, :index]
  resources :sent_scheduled_messages, only: [:index]
  resources :scheduled_messages, only: [:new, :create, :index, :edit, :update, :destroy] do
    resources :test_messages, only: [:new, :create]
  end
  resources :messages, only: [:new, :create, :index] do
    resources :send_messages, only: [:create]
    resources :test_messages, only: [:new, :create]
  end
end
