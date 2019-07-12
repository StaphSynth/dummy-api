module Api
  module V1
    class UsersController < ApplicationController
      def index
        users = paginate User.all
        options = PaginationMetadata.new(request, users).perform

        render json: UserSerializer.new(users, options).serialized_json
      end

      def show
        render json: user.to_json
      end

      def create
        respond_501
      end

      def update
        respond_501
      end

      def destroy
        respond_501
      end

      private

      def user
        @user ||= User.find(params[:id])
      end

      def user_params
        params.require(:user).permit(:name, :phone_number, :email)
      end
    end
  end
end
