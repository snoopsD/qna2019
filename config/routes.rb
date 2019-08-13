Rails.application.routes.draw do

  devise_for :users

  concern :votable do
    member do
      post :voteup
      post :votedown
    end
  end

  resources :users do
    resources :badges, only: %i[index]
  end
  
  resources :questions, concerns: [:votable], shallow: true do
    resources :answers, concerns: [:votable] do
      patch :best, on: :member
    end  
  end  

  resources :attachments, only: :destroy
  resources :links, only: :destroy

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
  
end
