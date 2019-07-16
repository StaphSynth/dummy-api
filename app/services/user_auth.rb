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
    JsonWebToken.encode(user_id: user.id, auth_token: user.auth_token)

  rescue JWT::EncodeError
    raise AuthenticationError
  end

  private

  attr_reader :headers, :params, :authenticating
  alias :authenticating? :authenticating

  def user
    @user ||= if authenticating?
      authenticate_user
    else
      authorize_user
    end
  end

  def authenticate_user
    user = User.find_by(email: params[:email])

    return user if user.present? &&
      user.authenticate(params[:password]) &&
      user.update_auth_token!

    raise AuthenticationError
  end

  def authorize_user
    user = User.find_by(id: decoded_jwt[:user_id])
    return user if user.present? && user.authenticate_auth_token(decoded_jwt[:auth_token])

    raise AuthorizationError
  end

  def decoded_jwt
    @decoded_jwt ||= JsonWebToken.decode(jwt)

  rescue JWT::DecodeError
    raise AuthorizationError
  end

  def jwt
    jwt = headers[:authorization]
    return jwt unless jwt.blank?

    raise AuthorizationError
  end
end
