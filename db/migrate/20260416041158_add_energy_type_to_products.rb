class AddEnergyTypeToProducts < ActiveRecord::Migration[8.1]
  def change
    add_column :products, :energy_type, :string
  end
end
