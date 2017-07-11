class AddSupplierIdToMasterFilms < ActiveRecord::Migration
  def change
    add_column :master_films, :Supplier_ID, :string
    add_column :master_films, :string, :string
  end
end
