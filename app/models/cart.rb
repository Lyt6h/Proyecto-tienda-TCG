class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy
  has_many :listings, through: :cart_items

  def total_quantity
    cart_items.sum(:quantity)
  end
end
