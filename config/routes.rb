Pcms::Application.routes.draw do

  scope 'amo', module: 'amo' do
    resources :job_orders do
      collection { get :new_import }
      collection { post :import }
    end

    resources :job_dates, only: [:index] do
      collection { get :be_schedule }
    end
  end

  get '/amo', to: redirect('/amo/job_dates')


  resources :films, except: [:new, :create] do
    member do
      post :split
      patch :restore
    end
    collection do
      get :edit_multiple
      patch :update_multiple
      get :formula_totals
      get :dimensions_map
      get :shelf_inventory
      get :qr_codes
    end
  end

  namespace :api, defaults: { format: 'json' } do
    post 'login', to: 'sessions#create'
    post 'logout', to: 'sessions#destroy'
    resources :films, only: [:show, :update], param: :serial do
      member do
        # using get for split for rack issue 676
        get :split
      end
      collection do
        patch :update_multiple
        get :assignable_orders
      end
    end
  end

  resources :master_films, except: [:show, :destroy] do
    collection do
      get :dimensions_map
      get :bvalue_series
    end
  end

  resources :sales_orders, except: [:show] do
    member do
      get :edit_ship_date
      patch :update_ship_date
      patch :move
    end
    collection do
      get :lead_time_histogram
      get :calendar
      get :product_type_totals
      get :assigned_formula_totals
    end
  end

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  post 'logout', to: 'sessions#destroy'

  scope module: "admin" do
    resources :users, except: :show
    resources :machines, except: :show
  end

  resources :film_movements, only: [:index] do
    collection do
      get :map
      get :inventory_totals
    end
  end

  resources :shipments, only: [:index] do
    collection do
      get :utilization_time_series
      get :shipped_area_time_series
    end
  end

  resources :productions, only: [:index] do
    collection do
      get :yield_time_series
      get :produced_area_time_series
      get :defects_time_series
    end
  end

  get 'planning/calendar', to: 'planning#calendar', as: :planning_calendar

  root to: 'films#index', phase: "lamination"
end
