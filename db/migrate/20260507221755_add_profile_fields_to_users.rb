class AddProfileFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :full_name, :string
    add_column :users, :phone_number, :string
    add_column :users, :street, :string
    add_column :users, :number, :string
    add_column :users, :apartment, :string
    add_column :users, :district, :string
    add_column :users, :city, :string
  end
end
