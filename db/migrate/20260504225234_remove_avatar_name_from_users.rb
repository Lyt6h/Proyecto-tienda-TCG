class RemoveAvatarNameFromUsers < ActiveRecord::Migration[8.1]
  def change
    remove_column :users, :avatar_name, :string
  end
end
