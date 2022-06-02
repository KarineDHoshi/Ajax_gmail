Rails.application.routes.draw do
  
  devise_for :users

  root to: "emails#index"
  resources :emails

  resources :tasks, except: [:show]

end
