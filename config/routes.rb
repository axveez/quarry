Rails.application.routes.draw do
  resources :galleries
  resources :heavy_equipments
  resources :backfills
  resources :quarries
  resources :fleets
  resources :locations
  resources :drivers
  resources :assets
  # resources :users
  resources :users, :path => 'user_management'
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "main#index"
  get '/todo(/:aksi(/:id))' => "main#todo"

  get '/quarries(/:id(/time_out))' => "quarries#time_out"
  get '/quarries(/:id(/upload))' => "quarries#upload"

end
