class SupportMessage < ApplicationRecord
  validates :name, :email, :message, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  scope :not_resolved, -> { where(resolved: false) }
  scope :ordered, -> { order(created_at: :desc) }
end
