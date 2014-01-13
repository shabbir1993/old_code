Pcms::Application.routes.draw do
  resources :films, except: [:new, :create, :show, :destroy] do
    member do
      get :split
      patch :create_split
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
      patch :return
    end
  end

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  get 'logout', to: 'sessions#destroy'

  scope module: "admin" do
    get 'imports', to: 'imports#forms'
    post 'import_master_films', to: 'imports#import_master_films'
    post 'import_films', to: 'imports#import_films'
    post 'import_users', to: 'imports#import_users'
    post 'import_machines', to: 'imports#import_machines'

    resources :users, except: :show
  end

  get 'history/film_movements', to: 'history#film_movements', as: :film_movements_history
  get 'history/fg_film_movements', to: 'history#fg_film_movements', as: :fg_film_movements_history
  get 'history/scrap_film_movements', to: 'history#scrap_film_movements', as: :scrap_film_movements_history
  get 'history/film_resizes', to: 'history#film_resizes', as: :film_resizes_history
  get 'history/film_deletes', to: 'history#film_deletes', as: :film_deletes_history

  get 'charts/stock_formula_totals', to: 'charts#stock_formula_totals', as: :stock_formula_totals_chart
  get 'charts/stock_film_type_totals', to: 'charts#stock_film_type_totals', as: :stock_film_type_totals_chart
  get 'charts/stock_dimensions', to: 'charts#stock_dimensions', as: :stock_dimensions_chart
  get 'charts/stock_snapshots', to: 'charts#stock_snapshots', as: :stock_snapshots_chart
  get 'charts/movement_summary', to: 'charts#movement_summary', as: :movement_summary_chart
  get 'charts/inventory', to: 'charts#inventory', as: :inventory_chart
  get 'charts/utilization', to: 'charts#utilization', as: :utilization_chart
  get 'charts/yield', to: 'charts#yield', as: :yield_chart


  root to: 'films#index', defaults: { scope: "lamination" }
end
