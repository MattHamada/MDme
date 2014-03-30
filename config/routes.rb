# Author: Matt Hamada
# Copyright MDme 2014
#
# Routing file
#


MDme::Application.routes.draw do

  require 'domains'

  #doctor subdomain
  match '/', to: 'doctors#signin', via: 'get', constraints: { subdomain: 'doctors' }


  #admin subdomain
  match '/',     to: 'admins#signin',           via: 'get',    constraints: { subdomain: 'admin' }
  #constraints(RootDomain) do
  #constraints subdomain: false do
  root 'static_pages#home', constraints: { subdomain: 'www' }
  #match '/signup',    to: 'patients#new',           via: 'get',    constraints: { subdomain: 'www' }
  match '/help',            to: 'static_pages#help',     via: 'get',    constraints: { subdomain: 'www' }
  match '/about',           to: 'static_pages#about',    via: 'get',    constraints: { subdomain: 'www' }
  match '/contact',         to: 'static_pages#contact',  via: 'get',    constraints: { subdomain: 'www' }
  match '/signin',          to: 'sessions#new',          via: 'get',    constraints: { subdomain: 'www' }
  match '/signout',         to: 'sessions#destroy',      via: 'delete'
  match '/forgot_password', to: 'password_reset#new',    via: 'get',    as: :forgot_password
  match '/forgot_password', to: 'password_reset#create', via: 'post',   as: :password_reset


  get  'patient/:patient_id/appointments/browse'         => 'patients/appointments#open_appointments', as: :open_appointments_browse
  get  'patients/:patient_id/appointments/open_requests' => 'patients/appointments#open_requests',     as: :open_requests
  get  'patients/:id/changepassword'                     => 'patients#change_password',                as: :patient_password
  post 'patients/:id/updatepassword'                     => 'patients#update_password',                as: :patient_update_password

  get  'admins/:admin_id/appointments/browse'            => 'admins/appointments#browse',              as: :appointments_browse
  get  'admins/:admin_id/appointments/new/browse'        => 'admins/appointments#new_browse',          as: :admin_open_appointments_browse
  get  'admins/:admin_id/appointments/approval'          => 'admins/appointments#approval',            as: :appointment_approval
  get  'admins/:admin_id/appointments/ondate'            => 'admins/appointments#show_on_date',        as: :appointment_show_on_date
  get  'admins/:admin_id/appointments/delays'            => 'admins/appointments#manage_delays',       as: :manage_delays
  post 'admins/:admin_id/appointments/delays'            => 'admins/appointments#add_delay',           as: :add_delay
  post 'admins/:admin_id/appointments/approvedeny'       => 'admins/appointments#approve_deny',        as: :appointment_approve_deny

  get  'doctors/:id/public'                              => 'doctors#show_public',                     as: :doctor_public_show
  get  'doctors/:id/changepassword'                      => 'doctors#change_password',                 as: :doctor_password
  post 'doctors/:id/updatepassword'                      => 'doctors#update_password',                 as: :doctor_update_password

  #resources :departments
  resources :patients
  resources :sessions, only: [:new, :create, :destroy]
  resources :admins
  resources :appointments
  resources :doctors

  #TODO go through [only] actions
  resources :doctors do
    resources :appointments, only: [:index, :show], controller: 'doctors/appointments'
    resources :patients,     only: [:index, :show], controller: 'doctors/patients'
  end

  resources :patients do
    resources :appointments, controller: 'patients/appointments'
    resources :doctors, only: [:index, :show], controller: 'patients/doctors'
  end

  resources :admins do
    resources :departments,  controller: 'admins/departments'
    resources :patients,     controller: 'admins/patients'
    resources :doctors,      controller: 'admins/doctors'
    resources :appointments, controller: 'admins/appointments'
  end




  #api routes
  # namespace :api, :version => 1 do
  #   resources :patients, :only => [:index, :show],
  # end


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
