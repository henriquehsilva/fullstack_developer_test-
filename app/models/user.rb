class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :user_imports, foreign_key: :creator_id, dependent: :destroy, inverse_of: :creator
  has_one_attached :avatar_image

  enum :role, { user: 0, admin: 1 }, default: :user, validate: true

  normalizes :email, with: ->(email) { email.strip.downcase }

  validates :full_name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role, presence: true
  validates :password, length: { minimum: 8, maximum: 72 }, allow_nil: true
  validates :avatar_url, format: {
    with: %r{\Ahttps?://[^\s]+\z},
    message: "must be a valid HTTP or HTTPS URL"
  }, allow_blank: true
  validate :avatar_image_is_valid

  after_commit :broadcast_dashboard_metrics

  def avatar_source
    avatar_image.attached? ? avatar_image : avatar_url.presence
  end

  private
    def avatar_image_is_valid
      return unless avatar_image.attached?

      unless avatar_image.blob.content_type.in?(%w[image/jpeg image/png image/webp])
        errors.add(:avatar_image, "must be a JPEG, PNG, or WebP image")
      end

      errors.add(:avatar_image, "must be smaller than 5 MB") if avatar_image.blob.byte_size > 5.megabytes
    end

    def broadcast_dashboard_metrics
      broadcast_replace_later_to(
        "admin_dashboard",
        target: "dashboard_metrics",
        partial: "admin/dashboard/metrics"
      )
    end
end
