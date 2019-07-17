class User < ApplicationRecord
  EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  has_many :posts

  before_create :set_auth_token,
    unless: Proc.new { |user| user.auth_token.present? }

  has_secure_password
  has_secure_password :auth_token, validations: false

  validates :name, {
    presence: true,
    length: { maximum: 80 }
  }

  validates :email, {
    presence: true,
    length: { maximum: 255 },
    format: { with: EMAIL_REGEX },
    uniqueness: { case_sensitive: false }
  }

  validates :phone_number, {
    allow_blank: true,
    length: { is: 10 },
    format: { with: /\A[0-9]{10}\z/ },
    uniqueness: true
  }

  alias_attribute :admin?, :admin

  def update_auth_token!
    set_auth_token
    save
  end

  private

  def set_auth_token
    self.auth_token = SecureRandom.hex(16)
  end
end
