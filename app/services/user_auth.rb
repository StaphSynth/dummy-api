class UserAuth
  class AuthenticationError < StandardError; end
  class AuthorizationError < StandardError; end

  def initialize(request)
    @headers = request.headers
    @params = request.params
    @authenticating = false
  end

  def authorize
    user
  end

  def authenticate
    @authenticating = true
    JsonWebToken.encode(user_id: user.id)

  rescue JWT::EncodeError
    raise AuthenticationError
  end

  private

  attr_reader :headers, :params, :authenticating
  alias :authenticating? :authenticating

  def user
    @user ||= begin
      if authenticating?
        authenticate_user
      else
        User.find(decoded_token[:user_id])
      end

    rescue ActiveRecord::RecordNotFound
      raise AuthorizationError
    end
  end

  def authenticate_user
    user = User.find_by(email: params[:email])
    return user if user.present? && user.authenticate(params[:password])

    raise AuthenticationError
  end

  def decoded_token
    @decoded_token ||= JsonWebToken.decode(token)

  rescue JWT::DecodeError
    raise AuthorizationError
  end

  def token
    token = headers[:authorization]
    return token unless token.blank?

    raise AuthorizationError
  end
end
