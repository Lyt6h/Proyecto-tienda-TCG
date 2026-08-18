class CreateCardsAndListings < ActiveRecord::Migration[8.1]
  def change
    create_table :cards do |t|
      t.string :name, null: false
      t.string :card_number
      t.string :expansion
      t.string :rarity
      t.string :energy_type
      t.integer :release_year
      t.string :image_url

      t.timestamps
    end

    create_table :listings do |t|
      t.references :seller, null: false, foreign_key: { to_table: :users }
      t.references :card, null: false, foreign_key: true
      t.decimal :price, null: false, precision: 10, scale: 2
      t.integer :stock, default: 1
      t.string :condition
      t.string :status, default: 'active'

      t.timestamps
    end
  end
end
