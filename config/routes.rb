Rails.application.routes.draw do

  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }
  resources :cards

  root 'cards#index'
  get '/update', to: 'cards#update'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
