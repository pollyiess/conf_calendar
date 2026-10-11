Rails.application.routes.draw do
  root "conferences#index" # Сделаем список конференций главной страницей сайта

  get "ui_kit", to: "ui_kit#index" if Rails.env.development?

  devise_for :users

  resources :conferences, only: [ :index, :show ]

  get "up" => "rails/health#show", as: :rails_health_check
end
