class Review < ApplicationRecord
  belongs_to :order_item

  validates :item_rating, presence: true, inclusion: { in: 1..5 }
  validates :seller_rating, presence: true, inclusion: { in: 1..5 }
  validates :order_item_id, uniqueness: true
  validates :comment, length: { maximum: 500 }
end
