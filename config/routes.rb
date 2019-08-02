Rails.application.routes.draw do

  devise_for :users

  resources :users do
    resources :badges, only: %i[index]
  end
  
  resources :questions, shallow: true do
    resources :answers do
      patch :best, on: :member
    end  
  end  

  resources :attachments, only: :destroy
  resources :links, only: :destroy

  root to: 'questions#index'
  
end
