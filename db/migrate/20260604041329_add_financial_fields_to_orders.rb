class AddFinancialFieldsToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :subtotal, :decimal, precision: 10, scale: 2, default: 0.0
    add_column :orders, :service_fee, :decimal, precision: 10, scale: 2, default: 0.0
    add_column :orders, :total_price, :decimal, precision: 10, scale: 2, default: 0.0
    add_column :orders, :buyer_notification_seen, :boolean, default: false
  end
end
