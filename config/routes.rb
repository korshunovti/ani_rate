Rails.application.routes.draw do
  get "favorites/index"
  scope "(:lang)", lang: /ru|en/ do
    devise_for :users
    authenticated :user do
      root "decisions#index", as: :authenticated_root
    end
    root to: redirect("/users/sign_in")
    resources :ratings, only: [:index]
    resources :favorites, only: [:index]
    namespace :api do
      get  "/animes/next", to: "animes#next"
      post "/ratings",     to: "ratings#create"
      post "/favorites/toggle", to: "favorites#toggle"
    end
  end
end
