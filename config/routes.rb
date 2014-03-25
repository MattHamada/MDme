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


  get 'patient/:id/appointments/browse'         => 'appointments#open_appointments', as: :open_appointments_browse
  get 'patients/:id/appointments/request'       => 'appointments#patient_request',   as: :request_appointment
  get 'patients/:id/appointments/edit_requests' => 'appointments#edit_requests',     as: :edit_requests
  get 'patients/:id/appointments/:appointment_id/edit'  => 'appointments#edit_request', as: :edit_request
  post 'patients/:id/appointments/:appointment_id/update' => 'appointments#update_request', as: :update_request
  get 'patients/:id/appointments'               => 'patients#appointments',          as: :patient_appointments
  get 'patients/:id/appointments/:appointment_id' => 'patients#appointment_show',   as: :patient_appointment

  get 'appointments/browse'                     => 'appointments#browse',            as: :appointments_browse
  get 'appointments/new/browse'                 => 'appointments#admin_new_browse',  as: :admin_open_appointments_browse
  get 'appointments/approval'                   => 'appointments#approval',          as: :appointment_approval
  get 'appointments/ondate'                     => 'appointments#show_on_date',      as: :appointment_show_on_date
  get 'appointments/delays'                     => 'appointments#manage_delays',     as: :manage_delays
  post 'appointments/delays'                    => 'appointments#add_delay',         as: :add_delay
  post 'appointments/approvedeny'               => 'appointments#approve_deny',      as: :appointment_approve_deny

  get 'doctors/:id/appointments'                => 'doctors#appointments',           as: :doctors_appointments
  get 'doctors/:id/patients'                    => 'doctors#patient_index',          as: :doctors_patients
  get 'doctors/:id/patients/:patient_id'        => 'doctors#patient_show',           as: :doctors_patient
  get 'doctors/:id/public'                      => 'doctors#show_public',            as: :doctor_public_show

  resources :departments
  resources :patients
  resources :sessions, only: [:new, :create, :destroy]
  resources :admins
  resources :appointments
  resources :doctors


  #api routes
  namespace :api, :version => 1 do
    resources :patients, :only => [:index, :show]
  end


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
