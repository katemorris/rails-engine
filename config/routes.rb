Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get '/revenue', to: 'revenue#index'
      # Items
      get '/items/find', to: 'items/search#show'
      get '/items/find_all', to: 'items/search#index'
      resources :items do
        get :merchants, to: 'items/merchants#index'
      end

      # Merchants
      get '/merchants/find', to: 'merchants/search#show'
      get '/merchants/find_all', to: 'merchants/search#index'
      get '/merchants/most_revenue', to: 'merchants/most_revenue#index'
      get '/merchants/most_items', to: 'merchants/most_items#index'
      resources :merchants do
        get :items, to: 'merchants/items#index'
        get :revenue, to: 'merchants/revenue#index'
      end
    end
  end
end
