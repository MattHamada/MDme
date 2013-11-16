MDme::Application.routes.draw do

  require 'domains'

  #constraints(Subdomain) do
   # constraints subdomain: 'doctors' do
    #    root 'doctors#home'
    #end
  #end

  #doctor subdomain
  match '/', to: 'doctors#signin', via: 'get', constraints: { subdomain: 'doctors' }


  #admin subdomain
  match '/',     to: 'admins#signin',           via: 'get',    constraints: { subdomain: 'admin' }
  #constraints(RootDomain) do
    #constraints subdomain: false do
    root 'static_pages#home', constraints: { subdomain: 'www' }
    match '/signup',    to: 'patients#new',           via: 'get',    constraints: { subdomain: 'www' }
    match '/help',      to: 'static_pages#help',      via: 'get',    constraints: { subdomain: 'www' }
    match '/about',     to: 'static_pages#about',     via: 'get',    constraints: { subdomain: 'www' }
    match '/contact',   to: 'static_pages#contact',   via: 'get',    constraints: { subdomain: 'www' }
    match '/signin',    to: 'sessions#new',           via: 'get',    constraints: { subdomain: 'www' }
    match '/signout',   to: 'sessions#destroy',       via: 'delete', constraints: { subdomain: 'www' }

    #get 'appointments/:year/:month/:day' => 'appointments#day', as: :day_appointments
    get 'appointments/browse' => 'appointments#browse', as: :appointments_browse

    resources :patients
    resources :sessions, only: [:new, :create, :destroy]
    resources :admins
    resources :appointments
    resources :doctors

   # end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
