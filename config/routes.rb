Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get '/merchants/find', to: 'merchants_search#show'

      get '/revenue/merchants', to: 'biz#top_merchants'
      get '/merchants/most_items', to: 'biz#most_items'
      get '/revenue', to: 'biz#total_revenue'
      get '/revenue/merchants/:id', to: 'biz#single_merchant'

      resources :merchants, only: %i[index show] do
        resources :items, only: [:index], controller: 'merchant_items'
      end

      get '/items/find_all', to: 'items_search#index'

      resources :items do
        resources :merchant, only: [:index], controller: 'item_merchants'
      end
    end
  end
end
