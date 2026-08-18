class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_one :cart, dependent: :destroy
  has_many :listings, foreign_key: :seller_id, dependent: :destroy
  has_many :client_orders, class_name: "Order", foreign_key: :client_id, dependent: :destroy
  has_many :seller_orders, class_name: "Order", foreign_key: :seller_id, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_cards, through: :favorites, source: :card
  has_one_attached :profile_picture

  normalizes :email_address, with: ->(email) { email.strip.downcase }
  normalizes :username, with: ->(username) { username.strip }

  validates :email_address, presence: true, uniqueness: { case_sensitive: false }
  validates :username, presence: true, uniqueness: { case_sensitive: false },
            format: { with: /\A[a-zA-Z0-9]+\z/, message: :invalid_characters }
  validates :password, length: { minimum: 6 }, allow_nil: true

  generates_token_for :password_reset, expires_in: 15.minutes

  def online?
    return false if last_seen_at.nil?

    last_seen_at > 7.minutes.ago
  end

  def banned?
    banned_at.present?
  end

  def active?
    banned_at.nil?
  end

  def profile_complete?
    full_name.present? && phone_number.present? && street.present?
    && number.present? && district.present? && city.present?
  end
end
