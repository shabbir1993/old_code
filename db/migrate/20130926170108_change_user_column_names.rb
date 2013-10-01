class ChangeUserColumnNames < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.rename :email, :username
      t.rename :name, :full_name
    end
  end
end
