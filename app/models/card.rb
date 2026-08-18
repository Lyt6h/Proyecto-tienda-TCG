class Card < ApplicationRecord
  has_many :listings, dependent: :destroy
  has_many :favorites, dependent: :destroy
  validates :name, presence: true
end
