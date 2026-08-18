class CleanupOldProductSystem < ActiveRecord::Migration[8.1]
  def change
    # Update cart_items to use listings instead of products
    remove_reference :cart_items, :product, foreign_key: true
    add_reference :cart_items, :listing, foreign_key: true

    # Drop old products table
    drop_table :products do |t|
      t.integer "condition_psa"
      t.datetime "created_at", null: false
      t.text "description"
      t.string "energy_type"
      t.string "name"
      t.integer "price"
      t.string "rarity"
      t.integer "release_year"
      t.integer "stock"
      t.datetime "updated_at", null: false
      t.bigint "user_id"
      t.index ["user_id"], name: "index_products_on_user_id"
    end
  end
end
