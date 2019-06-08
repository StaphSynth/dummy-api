module Api
  module V1
    class UsersController < ApplicationController
      before_action :set_user, only: [:show, :update, :destroy]

      def index
        @users = User.all
        respond_with(@users)
      end

      def show
        respond_with(@user)
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
