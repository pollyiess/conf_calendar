Rails.application.routes.draw do
  get "ui_kit/index"
  root "pages#home"

  # Роут для UI Kit (будет работать только в режиме разработки)
  if Rails.env.development?
    get "ui_kit", to: "ui_kit#index"
  end

  devise_for :users

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check
end