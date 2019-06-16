module Api
  module V1
    class PostsController < ApplicationController
      before_action :set_post, only: [:show, :update, :destroy]

      def index
        @posts = Post.all
        respond_with PostSerializer.new(@posts).serialized_json
      end

      def show
        respond_with PostSerializer.new(@post)
      end

      def create
        @post = Post.new(post_params)
        @post.save
        respond_with(@post)
      end

      def update
        @post.update(post_params)
        respond_with(@post)
      end

      def destroy
        @post.destroy
        respond_with(@post)
      end

    private
      def set_post
        @post = Post.find(params[:id])
      end

      def post_params
        params.require(:post).permit(:title, :body)
      end
    end
  end
end
