module Api
  module V1
    class AuthenticationController < ApplicationController
      def authenticate
        render json: { token: UserAuth.new(request).authenticate }

      rescue UserAuth::AuthenticationError
        respond_401
      end
    end
  end
end
