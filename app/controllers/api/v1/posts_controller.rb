module Api
  module V1
    class PostsController < ApplicationController
      def index
        posts = paginate Post.all
        options = PaginationMetadata.new(request, posts).perform

        render json: PostSerializer.new(posts, options).serialized_json
      end

      def show
        render json: post.to_json
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

      def post
        @post = Post.find(params[:id])
      end

      def post_params
        params.require(:post).permit(:title, :body)
      end
    end
  end
end
