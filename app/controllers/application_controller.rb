require 'application_responder'

class ApplicationController < ActionController::API
  include DefaultResponses

  self.responder = ApplicationResponder
  respond_to :json

  attr_reader :current_user

  rescue_from ActionController::UnknownFormat, with: :respond_400
  rescue_from ActionController::ParameterMissing, with: :respond_400
  rescue_from ActiveRecord::RecordNotFound, with: :respond_404

  private

  def authorize_api_request
    @current_user = UserAuth.new(request).authorize
    respond_401 if @current_user.blank?

  rescue UserAuth::AuthorizationError
    respond_401
  end
end
