class Listing < ApplicationRecord
  belongs_to :seller, class_name: "User"
  belongs_to :card
  has_many :cart_items, dependent: :destroy
  has_many :order_items, dependent: :destroy

  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :stock, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :status, inclusion: { in: %w[active sold_out] }
end
