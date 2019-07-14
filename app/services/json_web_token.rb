require 'jwt'

module JsonWebToken
  def self.encode(payload, exp = 1.day.from_now)
    payload[:exp] = exp.to_i
    payload[:iat] = Time.now.to_i

    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end

  def self.decode(token)
    body = JWT.decode(token, Rails.application.secrets.secret_key_base).first
    HashWithIndifferentAccess.new(body)
  end
end
