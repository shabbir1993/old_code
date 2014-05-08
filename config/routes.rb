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
    end
  end

  resources :master_films, except: [:show, :destroy]

  resources :sales_orders, except: [:show] do
    member do
      get :edit_ship_date
      patch :update_ship_date
      patch :move
    end
  end

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'

  scope module: "admin" do
    get 'imports', to: 'imports#forms'
    post 'import_master_films', to: 'imports#import_master_films'
    post 'import_films', to: 'imports#import_films'
    post 'import_machines', to: 'imports#import_machines'

    resources :users, except: :show
  end

  resources :film_movements, only: [:index] do
    collection do
      get :map
    end
  end

  get 'charts/stock_formula_totals', to: 'charts#stock_formula_totals', as: :stock_formula_totals_chart
  get 'charts/stock_film_type_totals', to: 'charts#stock_film_type_totals', as: :stock_film_type_totals_chart
  get 'charts/stock_dimensions', to: 'charts#stock_dimensions', as: :stock_dimensions_chart
  get 'charts/shelf_inventory', to: 'charts#shelf_inventory', as: :shelf_inventory_chart
  get 'charts/utilization', to: 'charts#utilization', as: :utilization_chart
  get 'charts/yield', to: 'charts#yield', as: :yield_chart
  get 'charts/lead_time', to: 'charts#lead_time', as: :lead_time_chart


  root to: 'films#index', tab: "lamination"
end
