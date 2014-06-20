Pcms::Application.routes.draw do
  resources :films, except: [:new, :create, :show] do
    member do
      post :split
      patch :restore
      patch :unassign
    end
    collection do
      get :edit_multiple
      patch :update_multiple
      get :formula_totals
      get :dimensions_map
      get :shelf_inventory
    end
  end

  resources :master_films, except: [:show, :destroy]

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
  get 'logout', to: 'sessions#destroy'

  scope module: "admin" do
    resources :users, except: :show
  end

  resources :film_movements, only: [:index] do
    collection do
      get :map
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
    end
  end

  get 'planning/calendar', to: 'planning#calendar', as: :planning_calendar

  root to: 'films#index', tab: "lamination"
end
