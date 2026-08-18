Rails.application.routes.draw do
  get "/mis_compras", to: "purchases#index", as: "purchases"
  scope "(:locale)", locale: /en|es/ do
    resource :session, only: [ :new, :create, :destroy ]
    resource :registration, only: [ :new, :create ]
    resource :profile, only: [ :show, :update ]
    resources :trainers, only: [ :show ]
    get "registration", to: "registrations#new" # Alias para manejar GETs accidentales a /registration
    resources :passwords, only: [ :new, :create, :edit, :update ], param: :token
    resources :favorites, only: [ :index, :create, :destroy ]

    resources :sales, only: [ :index ] do
      member do
        patch :accept
        patch :reject
      end
    end

    get "soporte", to: "support#new", as: "support"
    post "soporte", to: "support#create"

    get "up" => "rails/health#show", as: :rails_health_check

    namespace :admin do
      get "dashboard" => "dashboard#index"
      get "financials", to: "financials#index", as: :financials
      resources :users, only: [ :show, :destroy ] do
        member do
          patch :ban
          patch :unban
          delete :destroy_review
        end
      end
      resources :listings, only: [ :destroy ], controller: "listings"
      resources :reviews, only: [ :destroy ], controller: "reviews"
      resources :support_messages, only: [ :index, :update, :destroy ]
    end

    resources :products, only: [ :index, :show, :new, :create, :edit, :update, :destroy ] do
      get :my_products, on: :collection
    end

    get "api_cards/search" => "api_cards#search", as: :api_cards_search
    post "api_cards/create_listing" => "api_cards#create_listing", as: :api_cards_create_listing

    resource :cart, only: [ :show ] do
      post :add_item, on: :member
      delete :remove_item, on: :member
      post :checkout, on: :member
    end

    resources :order_items, only: [] do
      resources :reviews, only: [ :new, :create ]
    end

    resources :reviews, only: [] do
      member do
        patch :report
      end
    end
    root "products#index"
  end
end
