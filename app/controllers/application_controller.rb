require 'application_responder'

class ApplicationController < ActionController::API
  include DefaultResponses

  self.responder = ApplicationResponder

  respond_to :json

  rescue_from ActionController::UnknownFormat, with: :respond_400
  rescue_from ActiveRecord::RecordNotFound, with: :respond_404
end
