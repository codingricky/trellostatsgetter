Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }

  resources :cards
  root 'cards#index'
  get '/update', to: 'cards#update'
  get '/save_all', to: 'cards#save_all'
  get '/stats', to: 'stats#index'
  get '/hires', to: 'hires#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
