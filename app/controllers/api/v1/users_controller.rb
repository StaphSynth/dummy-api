module Api
  module V1
    class UsersController < ApplicationController
      before_action :set_user, only: [:show, :update, :destroy]

      def index
        users = paginate User.all
        options = PaginationMetadata.new(request, users).perform

        render json: UserSerializer.new(users, options).serialized_json
      end

      def show
        render json: UserSerializer.new(@user).serialized_json
      end

      def create
        @user = User.new(user_params)
        @user.save
        respond_with(@user)
      end

      def update
        @user.update(user_params)
        respond_with(@user)
      end

      def destroy
        @user.destroy
        respond_with(@user)
      end

      private

      def set_user
        @user = User.find(params[:id])
      end

      def user_params
        params.require(:user).permit(:name, :phone_number, :email)
      end
    end
  end
end
