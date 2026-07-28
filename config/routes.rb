Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: "users/sessions" }
  root to: "home#index"
  get "/app", to: "app#show", as: :app

  get "/modal/close", to: "modals#close", as: :close_modal

  resources :lists do
    resources :items, except: [ :index, :show ]
  end
end
