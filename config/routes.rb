Rails.application.routes.draw do
  devise_for :members
  get 'pages/test1'

  get 'pages/test2'

  get 'pages/test3'

  get 'pages/test4'

  get 'pages/test5'

  get 'pages/test6'

  get 'pages/test7'


  root 'urls#index'

  get 'urls/scan_all', to: 'urls#scan_all', as: 'scan_all'
  get 'urls/scan/:id', to: 'urls#scan', as: 'scan'
  get 'urls/copy/:id', to: 'urls#copy', as: 'copy'

  resources :urls
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
