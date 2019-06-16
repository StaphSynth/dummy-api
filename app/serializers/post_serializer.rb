class PostSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :title, :body, :created_at, :updated_at

  belongs_to :user
end
