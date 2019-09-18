require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end  

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  devise_scope :user do
    post '/register' => 'oauth_callbacks#register'
  end

  concern :votable do
    member do
      post :voteup
      post :votedown
    end
  end

  concern :commentable do
    resources :comments, shallow: true, only: :create
  end

  resources :users do
    resources :badges, only: %i[index]
  end
  
  resources :questions, concerns: %i[votable commentable], shallow: true do
    resources :answers, concerns: %i[votable commentable] do
      patch :best, on: :member
    end 

    resources :subscriptions, shallow: true, only: %i[create destroy]
  end   
 
  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
        get :index, on: :collection
      end

      resources :questions do
        resources :answers, shallow: true
      end        
    end
  end

  get 'search', controller: :searches, action: :find

  resources :attachments, only: :destroy
  resources :links, only: :destroy

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
  
end
