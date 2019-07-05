Rails.application.routes.draw do

  devise_for :users
  resources :questions, shallow: true do
    delete :remove_attachments, on: :member
    resources :answers do
      patch :best, on: :member
      delete :remove_attachments, on: :member
    end  
  end

  root to: 'questions#index'
  
end
