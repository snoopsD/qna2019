Rails.application.routes.draw do

  devise_for :users

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
  end  

  resources :attachments, only: :destroy
  resources :links, only: :destroy

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
  
end
