class Order < ApplicationRecord
  belongs_to :client, class_name: "User"
  belongs_to :seller, class_name: "User"
  has_many :order_items, dependent: :destroy
  has_many :listings, through: :order_items

  validates :status, inclusion: { in: %w[pending_approval accepted delivered rejected completed] }
  validates :subtotal, :service_fee, :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
