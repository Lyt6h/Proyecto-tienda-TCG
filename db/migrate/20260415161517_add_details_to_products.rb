class AddDetailsToProducts < ActiveRecord::Migration[8.1]
  def change
    add_column :products, :release_year, :integer
    add_column :products, :condition_psa, :integer
    add_column :products, :rarity, :string
  end
end
