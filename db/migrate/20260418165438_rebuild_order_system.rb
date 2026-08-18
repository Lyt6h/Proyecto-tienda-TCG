class RebuildOrderSystem < ActiveRecord::Migration[8.1]
  def change
    create_table :orders do |t|
      t.references :client, null: false, foreign_key: { to_table: :users }
      t.references :seller, null: false, foreign_key: { to_table: :users }
      t.string :status

      t.timestamps
    end

    create_table :order_items do |t|
      t.references :order, null: false, foreign_key: true
      t.references :listing, null: false, foreign_key: true
      t.decimal :unit_price, precision: 10, scale: 2
      t.integer :quantity

      t.timestamps
    end

    create_table :reviews do |t|
      t.references :order_item, null: false, foreign_key: true, index: { unique: true }
      t.integer :item_rating
      t.integer :seller_rating
      t.text :comment

      t.timestamps
    end
  end
end
