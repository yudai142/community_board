Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'topics#index'
  resources :topics do
    resources :comments, only: [:create, :new]
    collection do
      get :new_check, to: 'topics#new_check'
      get :delete_select, to: 'topics#delete_select'
      get :delete_check, to: 'topics#delete_check'
      get :show2, to: 'topics#show2'
      get :show3, to: 'topics#show3'
    end
    member do
      get :index_sort, to: 'topics#index_sort'
      get :index_category, to: 'topics#index_category'
      post :vote, to: 'topics#vote',   as: 'vote'
    end
  end
end
