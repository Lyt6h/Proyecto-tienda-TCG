class AddDetailsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :username, :string, null: false
    add_index :users, :username, unique: true
    add_column :users, :is_admin, :boolean, default: false, null: false
    add_column :users, :avatar_name, :string
  end
end
